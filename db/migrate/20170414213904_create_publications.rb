class CreatePublications < ActiveRecord::Migration[4.2]
  def up
    create_table :publications, id: false do |t|
      t.text :id, null: false
      t.integer :pmid, null: false
      t.text :citation
      t.timestamps
    end
    execute 'ALTER TABLE publications ADD PRIMARY KEY (id)'
    add_index :publications, [:pmid], unique: true
  end
  
  def down
  	drop_table :publications
  end
end
