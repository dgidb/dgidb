class CreateInteractionsPublicationsTable < ActiveRecord::Migration
	def up
		create_table :interactions_publications, id: false do |t|
			t.text :interaction_id, null: false
			t.text :publication_id, null: false
		end
		execute 'ALTER TABLE interactions_publications ADD PRIMARY KEY (interaction_id, publication_id)'
    	execute 'ALTER TABLE interactions_publications ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id)'
    	execute 'ALTER TABLE interactions_publications ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES publications(id)'
	end

	def down
		drop_table :interactions_publications
	end
end
