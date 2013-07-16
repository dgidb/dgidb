module Genome
  module Importers
    module DSL
      class Node
        def initialize(item_id, importer_instance, row_instance, type)
          @id = item_id
          @importer = importer_instance
          @row = row_instance
          @type = type
          @defaults = { transform: ->(x) { x }, unless: ->(x) { false } }
        end

        def attribute(column, opts)
          opts = @defaults.merge opts
          create_entity(:attribute, get_val(column, opts), opts)
        end

        def attributes(column, opts)
          opts = @defaults.merge opts
          @row.send(column).each do |item|
            val = opts[:transform].call(item)
            create_entity(:attribute, val, opts)
          end
        end

        def name(column, opts)
          opts = @defaults.merge opts
          create_entity(:alias, get_val(column, opts), opts)
        end

        def names(column, opts)
          opts = @defaults.merge opts
          @row.send(column).each do |item|
            val = opts[:transform].call(item)
            create_entity(:alias, val, opts)
          end
        end

        private
        def get_val(column, opts)
          opts = @defaults.merge opts
          if column.is_a?(Symbol)
            opts[:transform].call(@row.send(column))
          else
            column
          end
        end

        def create_entity(property_type, val, opts)
          if !opts[:unless].call(val)
            if property_type == :alias
                @importer.send("create_#{@type}_alias", "#{@type}_id".to_sym => @id, alias: val, nomenclature: opts[:nomenclature])
            elsif property_type == :attribute
                @importer.send("create_#{@type}_attribute", "#{@type}_id".to_sym => @id, name: opts[:name], value: val)
            else
              raise "#{property_type} is not a valid property type!"
            end
          end
        end
      end
    end
  end
end
