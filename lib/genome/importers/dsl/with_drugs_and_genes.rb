module Genome
  module Importers
    module DSL
      module WithDrugsAndGenes
        attr_accessor :gene_claim, :drug_claim
        def initialize(item_id, importer_instance, row_instance)
          super(item_id, importer_instance, row_instance, 'interaction_claim')
        end

        def gene(column, opts = {}, &block)
          opts = @defaults.merge opts
          val = opts[:transform].call(@row.send(column))
          if !opts[:unless].call(val)
            @gene_claim_id = @importer.create_gene_claim(name: val, nomenclature: opts[:nomenclature])
            node = GeneNode.new(@gene_claim_id, @importer, @row)
            node.instance_eval(&block)
          end
        end

        def drug(column, opts = {}, &block)
          opts = @defaults.merge opts
          val = opts[:transform].call(@row.send(column))
          if !opts[:unless].call(val)
            @drug_claim_id = @importer.create_drug_claim(name: val, nomenclature: opts[:nomenclature], primary_name: opts[:transform].call(@row.send(opts[:primary_name])))
            node = DrugNode.new(@drug_claim_id, @importer, @row)
            node.instance_eval(&block)
          end
        end
      end
    end
  end
end
