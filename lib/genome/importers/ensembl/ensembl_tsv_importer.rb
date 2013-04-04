module Genome
  module Importers
    module Ensembl

      def source_info
        {
          base_url:           'http://useast.ensembl.org/Homo_sapiens/Gene/Summary?g=',
          site_url:           'http://ensembl.org/index.html',
          citation:           'Ensembl 2011. Flicek P, Amode MR, ..., Vogel J, Searle SM. Nucleic Acids Res. 2011 Jan;39(Database issue)800-6. Epub 2010 Nov 2. PMID: 21045057.',
          source_db_version:  '68_37',
          source_type_id:     DataModel::SourceType.GENE,
          source_db_name:     'Ensembl',
          full_name:          'Ensembl'
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, EnsemblRow, source_info do
          gene :ensembl_id, nomenclature: 'Ensembl Gene Id' do
            name :ensembl_id, nomenclature: 'Ensembl Gene Id', transform: ->(x) { x.upcase }
            name :ensembl_gene_symbol, nomenclature: 'Ensembl Gene Name', transform: ->(x) { x.upcase }, unless: ->(x) { x.downcase == 'n/a' }
            attribute :ensembl_gene_biotype,  name: 'Gene Biotype', transform: ->(x) { x.upcase }, unless: ->(x) { x.downcase == 'n/a' }
          end
        end
      end
    end
  end
end
