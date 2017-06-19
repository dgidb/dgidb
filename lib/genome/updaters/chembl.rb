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

      def self.mol_col_hash
        @mol_col_hash ||= DataModel::ChemblMolecule.columns_hash
      end

      def self.syn_col_hash
        @syn_col_hash ||= DataModel::ChemblMoleculeSynonym.columns_hash
      end

      def self.add_records_from_db
        new_records = []
        @connection = PG.connect(dbname: chembl_db_name)
        i = 0
        connection.exec( "SELECT * FROM molecule_dictionary").each do |record|
          new_records << get_params(record, mol_col_hash)
          unless i % 50000
            DataModel::ChemblMolecule.create(new_records)
            new_records = []
          end
          i += 1
        end

        DataModel::ChemblMolecule.create(new_records)
      end

      def self.get_params(record, col_hash)
        params = {}

        record.each do |k, v|
          ks = k.to_sym
          if col_hash[k].type == :boolean
            params[ks] = flag(v)
          else
            params[ks] = v
          end
        end

        return params
      end

      def self.add_synonyms_from_db
        new_synonyms = []
        i = 0
        connection.exec("SELECT * FROM molecule_synonyms").each do |record|
          new_synonyms << get_params(record, syn_col_hash)
          unless i % 50000
            DataModel::ChemblMoleculeSynonym.create(new_synonyms)
            new_synonyms = []
          end
          i += 1
        end
      end
    end
  end
end