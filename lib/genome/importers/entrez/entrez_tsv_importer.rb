module Genome
  module Importers
    module Entrez

      @source_info = {
        base_url: 'http://www.ncbi.nlm.nih.gov/gene?term=',
        site_url: 'http://www.ncbi.nlm.nih.gov/gene',
        citation: 'Entrez Gene: gene-centered information at NCBI. Maglott D, Ostell J, Pruitt KD, Tatusova T. Nucleic Acids Res. 2011 Jan;39(Database issue)52-7. Epub 2010 Nov 28. PMID: 21115458.',
        source_db_version: '17-Sep-2012',
        source_type_id: DataModel::SourceType.GENE,
        source_db_name: 'Entrez',
        full_name: 'NCBI Entrez Gene'
      }

      def self.run(tsv_path)
        TSVImporter.import tsv_path, EntrezRow, @source_info do
          gene :entrez_id, nomenclature: 'Entrez Gene Id' do
            name :description, nomenclature: 'Gene Description'
            name :entrez_id, nomenclature: 'Entrez Gene Id', transform: ->(x) { x.upcase }
            name :entrez_gene_symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            names :entrez_gene_synonyms, nomenclature: 'Gene Synonyms', transform: ->(x) { x.upcase}, unless: ->(x) { x.blank? || x.downcase == 'n/a' }
            names :ensembl_ids, nomenclature: 'Ensembl Gene Id', transform: ->(x) { x.upcase }, unless: ->(x) { x.blank? || x.downcase == 'n/a' }
          end
        end
      end
    end
  end
end

