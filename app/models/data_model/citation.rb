class DataModel::Citation < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'citation'
end
