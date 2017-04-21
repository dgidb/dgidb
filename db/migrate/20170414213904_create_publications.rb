class CreatePublications < ActiveRecord::Migration
  def up
    create_table :publications do |t|
      t.integer :pmid
      t.text :citation

      t.timestamps
    end

    add_index :publications, [:pmid], unique: true
  end
  def down
  	drop_table :publications
  end
end
