require 'pg'

module Genome
  module Updaters
    class Chembl
      def chembl_db_name
        'chembl_23'
      end

      def add_records_from_db
        conn = PG.connect(dbname: chembl_db_name)
        conn.exec( "SELECT * FROM molecule_dictionary").each do |record|

        end
      end
    end
  end
end