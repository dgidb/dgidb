#require 'uuidtools'
module Genome
  module Extensions
    module UUIDPrimaryKey
      extend ActiveSupport::Concern
      included do
        self.primary_key = 'id'
        before_create :generate_uuid

        def generate_uuid
          #self.id = UUIDTools::UUID.random_create.to_s
        end
      end
    end
  end
end