class AddIndicesToDrugAttributesForDrugGrouper < ActiveRecord::Migration[5.1]
  def change
    add_index :drug_attributes, 'upper(name)', name: 'drug_attributes_index_on_upper_name'
    add_index :drug_attributes, 'upper(value)', name: 'drug_attributes_index_on_upper_value'
  end
end
