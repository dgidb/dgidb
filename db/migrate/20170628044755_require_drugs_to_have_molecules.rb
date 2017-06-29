class RequireDrugsToHaveMolecules < ActiveRecord::Migration[5.1]
  def change
    change_column_null :drugs, :chembl_id, false
  end
end
