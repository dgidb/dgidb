class AddFulltextIndexes < ActiveRecord::Migration[4.2]
  def up
    execute "CREATE INDEX drugs_full_text ON drugs USING gin (to_tsvector('english'::regconfig, name));"
    execute "CREATE INDEX drug_claim_aliases_full_text ON drug_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));"
    execute "CREATE INDEX drug_claims_full_text ON drug_claims USING gin (to_tsvector('english'::regconfig, name));"
    execute "CREATE INDEX genes_full_text ON genes USING gin (to_tsvector('english'::regconfig, name));"
    execute "CREATE INDEX gene_claim_aliases_full_text ON gene_claim_aliases USING gin (to_tsvector('english'::regconfig, alias));"
    execute "CREATE INDEX gene_claims_full_text ON gene_claims USING gin (to_tsvector('english'::regconfig, name));"
  end

  def down
    execute "DROP INDEX drugs_full_text"
    execute "DROP INDEX drug_claim_aliases_full_text"
    execute "DROP INDEX drug_claims_full_text"
    execute "DROP INDEX genes_full_text"
    execute "DROP INDEX gene_claim_aliases_full_text"
    execute "DROP INDEX gene_claims_full_text"
  end
end
