module Genome
  module Importers
    module Go

      def self.source_info
        {
          base_url:           'http://amigo.geneontology.org/amigo/search/bioentity?fq=taxon_subset_closure_label:%22Homo%20sapiens%22&sfq=document_category:%22bioentity%22&q=',
          site_url:           'http://www.geneontology.org/',
          citation:           'Gene ontology: tool for the unification of biology. The Gene Ontology Consortium. Ashburner M, Ball CA, ..., Rubin GM, Sherlock G. Nat Genet. 2000 May;25(1):25-9. PMID: 10802651.',
          source_db_version:  '29-Jul-2017',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'GO',
          full_name:          'The Gene Ontology'
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' || x == '-'}
        TSVImporter.import tsv_path, GoRow, source_info do
          gene :gene_name, nomenclature: 'Gene Symbol' do
            names :uniprot_ids, nomenclature: 'UniProt ID', unless: blank_filter
            category :gene_category
          end
        end.save!
      end
    end
  end
end
