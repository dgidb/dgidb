require 'zlib'
require 'net/ftp'
require 'tempfile'

module Genome
  module Updaters
    class GetPubchem
      def self.run!
        ActiveRecord::Base.logger.level = 1
        puts 'Deleting existing PubChem entries'
        Utils::Database.delete_source('PubChem')
        getter = GetPubchem.new
        puts 'Creating tmp file for staging...'
        tmpfile = Tempfile.new('pubchem_download')
        puts 'Downloading PubChem file...'
        getter.download_file(tmpfile.path)
        puts 'Processing PubChem file...'
        getter.process_pubchem_file(tmpfile.open)
      ensure
        puts 'Cleaning up tmpfile...'
        tmpfile.close
        tmpfile.unlink
        puts 'Done.'
      end

      def download_file(destination_path)
        Net::FTP.open(pubchem_ftp_server) do |ftp|
          ftp.passive = true
          ftp.login
          ftp.getbinaryfile(pubchem_file_path, destination_path)
        end
      end

      #This file takes the format of compound_id\tname
      #sorted by perceived quality, with the first entry for a given ID
      #being the "primary" PubChem name
      def process_pubchem_file(pubchem_file)
        alternate_names = []
        current_id = nil
        lines_processed = 0
        Zlib::GzipReader.new(pubchem_file).each_line do |line|
          (cid, name) = line.split("\t")
          lines_processed += 1
          if (current_id != cid)
            process_drug(current_id, alternate_names) unless current_id.nil?
            current_id = cid
            alternate_names = []
          end
          if name.size <= 250
            alternate_names << name
          end
          if lines_processed % 1_000_000 == 0
            puts "Processed #{lines_processed}..."
          end
        end
      end

      def process_drug(current_id, alternate_names)
        if alternate_names.any? { |name| existing_drugs[name.upcase.strip] }
          pubchem_primary_name = alternate_names.first.upcase.strip
          drug_claim = DataModel::DrugClaim.create(
            {
              source: source,
              nomenclature: 'pubchem',
              name: pubchem_primary_name,
              primary_name: pubchem_primary_name,
            },
            without_protection: true
          )
          DataModel::DrugClaimAlias.create(
            {
              alias: pubchem_primary_name,
              nomenclature: 'pubchem_primary_name',
              drug_claim: drug_claim
            },
            without_protection: true
          )
          DataModel::DrugClaimAlias.create(
            {
              alias: current_id,
              nomenclature: 'PubChem CID',
              drug_claim: drug_claim
            },
            without_protection: true
          )
          alternate_names[1..-1].each do |name|
            DataModel::DrugClaimAlias.create(
              {
                alias: name.strip.upcase,
                nomenclature: 'Drug Synonym',
                drug_claim: drug_claim
              },
              without_protection: true
            )
          end
        end
      end

      def existing_drugs
        @existing_drugs ||= DataModel::DrugClaim.includes(:drug_claim_aliases).all.inject({}) do |h, drug_claim|
          h[drug_claim.name.upcase] = true
          drug_claim.drug_claim_aliases.each do |a|
            h[a.alias.upcase] = true
          end
          h
        end
      end

      def pubchem_file_path
        'pubchem/Compound/Extras/CID-Synonym-filtered.gz'
      end

      def pubchem_ftp_server
        'ftp.ncbi.nlm.nih.gov'
      end

      def source
        @source ||= DataModel::Source.where(
          site_url: 'https://pubchem.ncbi.nlm.nih.gov/',
          base_url: 'http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?cid=',
          citation: "PubChem's BioAssay Database. Wang Y, Xiao J, ..., Gindulyte A, Bryant SH. Nucleic Acids Res. 2012 Jan;40(Database issue):D400-12. Epub 2011 Dec 2. PMID: 22140110",
          source_db_version: version,
          source_type_id: DataModel::SourceType.DRUG,
          source_db_name: 'PubChem',
          source_trust_level_id: DataModel::SourceTrustLevel.NON_CURATED,
          full_name: 'PubChem',
          license: '',
          license_url: 'https://pubchemdocs.ncbi.nlm.nih.gov/downloads',
        ).first_or_create
      end

      def version
        Date.today.strftime("%d-%b-%Y")
      end
    end
  end
end
