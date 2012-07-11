class DataModel::Citation < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'citation'
  has_many :genes
  has_many :drugs
  has_many :interactions
end
