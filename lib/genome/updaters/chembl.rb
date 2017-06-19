require 'pg'

module Genome
  module Updaters
    class Chembl
      def self.chembl_db_name
        'chembl_23'
      end

      def self.flag(string)
        h = {
            '0'=>false,
            '1'=>true,
        }
        return h[string]
      end

      def self.col_hash
        @col_hash ||= DataModel::ChemblMolecule.columns_hash
      end

      def self.add_records_from_db
        new_records = []
        conn = PG.connect(dbname: chembl_db_name)
        i = 0
        conn.exec( "SELECT * FROM molecule_dictionary").each do |record|
          params = {}

          record.each do |k, v|
            ks = k.to_sym
            if col_hash[k].type == :boolean
              params[ks] = flag(v)
            else
              params[ks] = v
            end
          end

          new_records << params
          unless i % 50000
            DataModel::ChemblMolecule.create(new_records)
            new_records = []
          end
          i += 1
        end

        DataModel::ChemblMolecule.create(new_records)
      end
    end
  end
end