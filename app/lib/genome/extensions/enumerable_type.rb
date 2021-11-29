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
          Rails.cache.fetch(enumerable_cache_key) do
            self.all.inject({}) do |hash, val|
              hash.tap do |h|
                key = transforms.inject(val.send(type_column)) do |curr, transform|
                  curr.send(*transform)
                end
                h[key] = val.id
              end
            end
          end
        end

        def self.enumerable_cache_key
          raise "You must implement enumerable_cache_key!"
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
