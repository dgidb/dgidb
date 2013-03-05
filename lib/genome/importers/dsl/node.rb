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
          val = opts[:transform].call(@row.send(column))
          if !opts[:unless].call(val)
            @importer.send("create_#{@type}_attribute", "#{@type}_id".to_sym => @id, name: opts[:name], value: val)
          end
        end

        def attributes(column, opts)
          opts = @defaults.merge opts
          @row.send(column).each do |item|
            val = opts[:transform].call(item)
            if !opts[:unless].call(val)
              @importer.send("create_#{@type}_attribute", "#{@type}_id".to_sym => @id, name: opts[:name], value: val)
            end
          end
        end

        def name(column, opts)
          opts = @defaults.merge opts
          val = opts[:transform].call(@row.send(column))
          if !opts[:unless].call(val)
            @importer.send("create_#{@type}_alias", "#{@type}_id".to_sym => @id, alias: val, nomenclature: opts[:nomenclature])
          end
        end

        def names(column, opts)
          opts = @defaults.merge opts
          @row.send(column).each do |item|
            val = opts[:transform].call(item)
            if !opts[:unless].call(val)
              @importer.send("create_#{@type}_alias", "#{@type}_id".to_sym => @id, alias: val, nomenclature: opts[:nomenclature])
            end
          end
        end
      end
    end
  end
end
