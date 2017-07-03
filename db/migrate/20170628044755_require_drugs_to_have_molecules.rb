class RequireDrugsToHaveMolecules < ActiveRecord::Migration[4.2]
  def change
    change_column_null :drugs, :chembl_id, false
  end
end
