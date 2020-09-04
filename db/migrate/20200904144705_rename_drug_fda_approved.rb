class RenameDrugFdaApproved < ActiveRecord::Migration[6.0]
  def change
    rename_column :drugs, :fda_approved, :approved
  end
end
