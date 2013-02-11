require 'genome/importers/delimited_row'
module Genome
  module Importers
    module TTD
      class TTDRow < Genome::Importers::DelimitedRow
        attribute :drug_id
        attribute :drug_name
        attribute :drug_synonyms, Array, delimiter: ';'
        attribute :drug_cas_number
        attribute :drug_pubchem_cid
        attribute :drug_pubchem_sid
        attribute :target_id
        attribute :target_name
        attribute :target_synonyms, Array, delimiter: ';'
        attribute :target_uniprot_id
        attribute :target_entrez_id
        attribute :target_ensembl_id
        attribute :interaction_types, Array, delimiter: ';'

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
