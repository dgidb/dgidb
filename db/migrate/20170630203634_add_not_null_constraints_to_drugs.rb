class AddNotNullConstraintsToDrugs < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:drugs, :name, false)
  end
end
