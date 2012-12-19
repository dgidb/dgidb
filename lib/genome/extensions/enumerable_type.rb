module Genome
  module Extensions
    module EnumerableType
      extend ActiveSupport::Concern
      included do
        self.inheritance_column = nil

        def self.method_missing(meth, *args, &block)
          all_types[meth.to_s.downcase] || super
        end

        private
        def self.all_types
          if Rails.cache.exist?(enumerable_cache_key)
            Rails.cache.fetch(enumerable_cache_key)
          else
            id_map = self.all.inject({}) do |hash, val|
              hash.tap do |h|
                key = transforms.inject(val.send(type_column)) do |curr, transform|
                  curr.send(*transform)
                end
                h[key] = val.id
              end
            end
            Rails.cache.write(enumerable_cache_key, id_map)
            id_map
          end
        end

        def self.enumerable_cache_key
          raise "You must implement  enumerable_cache_key!"
        end

        def self.type_column
          :type
        end

        def self.transforms
          [:downcase]
        end
      end
    end
  end
end
