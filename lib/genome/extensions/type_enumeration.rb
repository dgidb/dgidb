module Genome
  module Extensions
    module TypeEnumeration
      extend ActiveSupport::Concern
      included do
        self.inheritance_column = nil

        def self.method_missing(meth, *args, &block)
          all_types[meth.to_s.downcase] || super
        end

        private
        def self.all_types
          if Rails.cache.exist?(cache_key)
            Rails.cache.fetch(cache_key)
          else
            id_map = self.all.inject({}) do |hash, val|
              hash.tap { |h| h[val.type] = val.id }
            end
            Rails.cache.write(cache_key, id_map)
            id_map
          end
        end

        def self.cache_key
          raise "You must implement cache key!"
        end
      end
    end
  end
end
