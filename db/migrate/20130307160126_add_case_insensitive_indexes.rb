class AddCaseInsensitiveIndexes < ActiveRecord::Migration[3.2]
  def tables_and_columns
    [
      ['drug_claim_types', 'type'],
      ['gene_claim_categories', 'name'],
      ['interaction_claim_types', 'type'],
      ['sources', 'source_db_name'],
      ['source_trust_levels', 'level']
    ]
  end

  def up
    tables_and_columns.each do |(table, column)|
      execute "CREATE INDEX #{table}_lower_#{column}_idx ON #{table} (lower(#{column}))"
    end
  end

  def down
    tables_and_columns.each do |(table, column)|
      execute "DROP INDEX #{table}_lower_#{column}_idx"
    end
  end
end
