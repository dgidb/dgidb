require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Pharmgkb
      class PharmgkbRow < Genome::Importers::DelimitedRow
        attribute :Interaction_id
        attribute :Entity1_id
        attribute :Entity1_type
        attribute :Entity2_id
        attribute :Entity2_type
        attribute :Evidence
        attribute :Association
        attribute :PK
        attribute :PD
        attribute :PMIDs
        attribute :Drug_Name
        attribute :Generic_Names, Array, delimiter: ','
        attribute :Trade_Names, Array, delimiter: ','
        attribute :Brand_Mixtures
        attribute :Drug_Type
        attribute :Drug_Cross_References, Array, delimiter: ','
        attribute :SMILES
        attribute :External_Vocabulary
        attribute :Entrez_Id
        attribute :Ensembl_Id
        attribute :Gene_Name
        attribute :Symbol
        attribute :Alternate_Names, Array, delimiter: ','
        attribute :Alternate_Symbols, Array, delimiter: ','
        attribute :Is_VIP
        attribute :Has_Variant_Annotation
        attribute :Gene_Cross_References

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
