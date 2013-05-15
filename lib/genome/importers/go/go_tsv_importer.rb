module Genome
  module Importers
    module Go
      
      def source_info
        {
          base_url:           'http://amigo.geneontology.org/cgi-bin/amigo/search.cgi?search_query=XXXXXXXX&search_constraint=gp&exact_match=1&action=new-search&gptype=all&speciesdb=all&taxid=9606&ont=all&evcode=all',
          site_url:           'http://www.geneontology.org/',
          citation:           'Gene ontology: tool for the unification of biology. The Gene Ontology Consortium. Ashburner M, Ball CA, ..., Rubin GM, Sherlock G. Nat Genet. 2000 May;25(1):25-9. PMID: 10802651.',
          source_db_version:  '30-Aug-2012',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'GO',
          full_name:          'The Gene Ontology'
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, GoRow, source_info do
          gene :go_name, nomenclature: 'GO Gene Name' do
            name :go_name, nomenclature: 'Go Gene Name'
            name :human_readable_name, nomenclature: 'Human Readable Name', transform: ->(x) {x.gsub!('-', ' ')}
            #TODO: deal with the mess that is alternate_symbol_references
            #TODO: deal with the unholy union of go_short_name, go_id, using go_description as the description column
            #TODO: do secondary_go_term if it doesn't match go_id
          end
        end
      end
    end
  end
end
