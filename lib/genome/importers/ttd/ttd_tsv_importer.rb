module Genome
  module Importers
    module TTD
      @source_info = {
        base_url:          'http://bidd.nus.edu.sg/group/cjttd/ZFTTD',
        site_url:          'http://bidd.nus.edu.sg/group/ttd/ttd.asp',
        citation:          "Update of TTD: Therapeutic Target Database. Zhu F, Han BC, ..., Zheng CJ, Chen YZ. Nucleic Acids Res. 38(suppl 1):D787-91, 2010. PMID: 19933260.",
        source_db_version:  '4.3.02 (2011.08.25)',
        source_type_id:    DataModel::SourceType.INTERACTION,
        source_db_name:    'TTD',
        full_name:         'Therapeutic Target Database'
      }

      def self.run(tsv_path)
        na_filter = ->(x) { x.upcase == 'N/A' }
        TSVImporter.import tsv_path, TTDRow, @source_info do
          interaction known_action_type: 'unknown' do
            attributes :interaction_types, name: 'Interaction Type'

            gene :target_id, nomenclature: 'TTD Partner Id' do
              names :target_synonyms, nomenclature: 'Gene Symptom', unless: na_filter
              name :target_uniprot_id, nomenclature: 'Uniprot Accession', unless: na_filter
              name :target_entrez_id, nomenclature: 'Entrez Gene Id', unless: na_filter
              name :target_ensembl_id, nomenclature: 'Ensembl Gene Id', unless: na_filter
            end

            drug :drug_id, nomenclature: 'TTD Drug Id', primary_name: :drug_name do
              name :drug_name, nomenclature: 'Primary Drug Name'
              name :drug_id, nomenclature: 'TTD Drug Id'
              names :drug_synonyms, nomenclature: 'Drug Synonym', unless: na_filter
              name :drug_cas_number, nomenclature: 'CAS Number', unless: na_filter
              name :drug_pubchem_cid, nomenclature: 'Pubchem CId', unless: na_filter
              name :drug_pubchem_sid, nomenclature: 'Pubchem SId', unless: na_filter
            end
          end
        end
      end
    end
  end
end