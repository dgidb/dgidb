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
              hash.tap do |h|
                key = transforms.inject(val.send(type_column)) do |curr, transform|
                  curr.send(*transform)
                end
                h[key] = val.id
              end
            end
            Rails.cache.write(cache_key, id_map)
            id_map
          end
        end

        def self.cache_key
          raise "You must implement cache key!"
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
