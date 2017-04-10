class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :pmid
      t.string :citation
      t.string :link

      t.timestamps
    end
  end
end
