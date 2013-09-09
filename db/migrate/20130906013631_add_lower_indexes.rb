class AddLowerIndexes < ActiveRecord::Migration
  def tables_and_columns
    [
      ['drugs', 'name'],
      ['genes', 'name'],
      ['gene_claim_aliases', 'alias'],
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
