module Genome
  module Importers
    module HopkinsGroom
      def source_info
        {
          base_url:           'http://www.uniprot.org/uniprot/',
          site_url:           'http://www.ncbi.nlm.nih.gov/pubmed/12209152/',
          citation:           'The druggable genome. Hopkins AL, Groom CR. Nat Rev Drug Discov. 2002 Sep;1(9):727-30. PMID: 12209152',
          source_db_version:  '11-Sep-2012',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'HopkinsGroom',
          full_name:          'The druggable genome (Hopkins & Groom, 2002)',
          licensei: 'Supplementary data from Nature Publishing Group copyright publication',
          license_link: 'https://www.nature.com/articles/nrd892',
        }
      end

      def self.run(tsv_path)
        na_filter = ->(x) { x.blank? || x.upcase == 'N/A' }
        upcase = ->(x) { x.upcase }
        TSVImporter.import tsv_path, HopkinsGroomRow, source_info do
          gene :uniprot_acc, nomenclature: 'HopkinsGroom Gene Name' do
            names :uniprot_acc, nomenclature: 'Uniprot Accession', transform: upcase ,unless: na_filter
            name :uniprot_id, nomenclature: 'Uniprot Id', transform: upcase, unless: na_filter
            name :uniprot_protein_name, nomenclature: 'Uniprot Protein Name', transform: upcase, unless: na_filter
            name :uniprot_gene_name, nomenclature: 'Uniprot Gene Name', transform: upcase, unless: na_filter
            name :entrez_id, nomenclature: 'Entrez Gene Id', transform: upcase, unless: na_filter
            names :ensembl_ids, nomenclature: 'Ensembl Gene Id', transform: upcase, unless: na_filter

            attribute 'DRUGGABLE GENOME', nomenclature: 'Human Readable Name'
            attribute :dgidb_human_readable, nomenclature: 'Human Readable Name', transform: ->(x) { x.gsub('-',' ').gsub('/', ' ').gsub('.', '_').upcase }, unless: na_filter
            attribute :interpro_acc, nomenclature: 'Interpro Acc'
            attribute :uniprot_evidence, nomenclature: 'Uniprot Evidence'
            attribute :uniprot_status, nomenclature: 'Uniprot Status'
            attribute :interpro_name, nomenclature: 'Interpro Name'
            attribute :interpro_short_name, nomenclature: 'Interpro Short Name'
            attribute :interpro_type, nomenclature: 'Interpro Type'
          end
        end
      end
    end
  end
end
