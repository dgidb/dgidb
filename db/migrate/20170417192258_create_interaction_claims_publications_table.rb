class CreateInteractionClaimsPublicationsTable < ActiveRecord::Migration
	def up
		create_table :interaction_claims_publications, id: false do |t|
			t.text :interaction_claim_id, null: false
			t.integer :publication_id, null: false
		end
		execute 'ALTER TABLE interaction_claims_publications ADD PRIMARY KEY (interaction_claim_id, publication_id)'
    	execute 'ALTER TABLE interaction_claims_publications ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims(id)'
    	execute 'ALTER TABLE interaction_claims_publications ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES publications(id)'
	end

	def down
		drop_table :interaction_claims_publications
	end
end
