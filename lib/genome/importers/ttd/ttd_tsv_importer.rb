require 'genome/online_updater'
module Genome; module Importers; module TTD
  class TTD < Genome::OnlineUpdater
    attr_reader :file_path, :source
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_source
      import_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('TTD')
    end

    def create_source
      @source ||= DataModel::Source.create(
        {
          base_url:          'http://db.idrblab.net/ttd/',
          site_url:          'http://bidd.nus.edu.sg/group/cjttd/',
          citation:          "Update of TTD: Therapeutic Target Database. Zhu F, Han BC, ..., Zheng CJ, Chen YZ. Nucleic Acids Res. 38(suppl 1):D787-91, 2010. PMID: 19933260.",
          source_db_version:  '2020.06.01',
          source_type_id:    DataModel::SourceType.INTERACTION,
          source_db_name:    'TTD',
          full_name:         'Therapeutic Target Database',
          license: 'Unclear. Website states "All Rights Reserved" but resource structure and description in 2002 publication indicate "open-access".',
          license_link: 'https://academic.oup.com/nar/article/30/1/412/1331814',
        }
      )
    end

    def import_claims
      CSV.foreach(file_path, :headers => true, :col_sep => ",") do |row|
        gene_name, gene_abbreviation = row['Target_Name'].split(' (', 2)
        gene_abbreviation.sub!(')', '')
        gene_claim = create_gene_claim(gene_name, 'TTD Target Name')
        create_gene_claim_alias(gene_claim, gene_abbreviation, 'TTD Gene Abbreviation')
        create_gene_claim_alias(gene_claim, row['TargetID'], 'TTD Target ID')

        drug_claim = create_drug_claim(row['Drug_Name'], row['Drug_Name'], 'TTD Drug Name')
        create_drug_claim_alias(drug_claim, row['DrugID'], 'TTD Drug ID')

        interaction_claim = create_interaction_claim(gene_claim, drug_claim)
        if !row['MOA'].nil? and !row['MOA'] == '.'
          create_interaction_claim_type(interaction_claim, Genome::Normalizers::InteractionClaimType.name_normalzier(row['MOA']))
        end
        #this is not a typo but the actual column header from the source TSV
        if !row['Referecnce'].nil?
          row['Referecnce'].split('; ').each do |ref|
            if ref.include? 'pubmed'
              url, sep, pmid = ref.rpartition('/')
              if pmid == ''
                pmid = url.rpartition('/').last
              end
              if !pmid == '217546303'
                create_interaction_claim_publication(interaction_claim, pmid)
              end
            end
            if ref.include? 'pmc'
              url, sep, pmcid = ref.rpartition('/')
              if pmcid == ''
                pmcid = url.rpartition('/').last
              end
              create_interaction_claim_publication_by_pmcid(interaction_claim, pmcid)
            end
          end
          create_interaction_claim_link(interaction_claim, 'TTD Target Information', "http://idrblab.net/ttd/data/target/details/#{row['TargetID']}")
        end
      end
    end
  end
end; end; end
