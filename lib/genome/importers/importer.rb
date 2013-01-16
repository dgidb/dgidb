module Genome
  module Importers
    class Importer
      def initialize
        @gene_claims                  = []
        @gene_claim_aliases           = []
        @gene_claim_attributes        = []
        @drug_claims                  = []
        @drug_claim_aliases           = []
        @drug_claim_attributes        = []
        @interaction_claims           = []
        @interaction_claim_attributes = []
        @source                       = create_source!
      end
      def import!
        update_progress('Constructing objects from TSV', 0)
        process_file
        store
      end

      private
      def create_source!
        raise 'You must implement create_source, which must create and return a source object'
      end
      def process_file
      end

      def store
        entity_names.inject(0) do |completed_count, entity|
          completed_count += store_entities(entity, completed_count)
        end
      end

      def create_gene_claim_alias(opts = {})
        DataModel::GeneClaimAlias.new.tap do |gca|
          gca.id            = SecureRandom.uuid
          gca.gene_claim_id = opts[:gene_claim_id]
          gca.alias         = opts[:alias]
          gca.nomenclature  = opts[:nomenclature]
          gca.description   = ''
          @gene_claim_aliases << gca
        end
      end

      def create_gene_claim_attribute(opts = {})
        DataModel::GeneClaimAttribute.new.tap do |gca|
          gca.id            = SecureRandom.uuid
          gca.gene_claim_id = opts[:gene_claim_id]
          gca.name          = opts[:name]
          gca.value         = opts[:value]
          gca.description       = opts[:description] || ''
          @gene_claim_attributes << gca
        end
      end

      def create_interaction_claim(opts = {})
        DataModel::InteractionClaim.new.tap do |ic|
          ic.id                = SecureRandom.uuid
          ic.drug_claim_id     = opts[:drug_claim_id]
          ic.gene_claim_id     = opts[:gene_claim_id]
          ic.known_action_type = opts[:known_action_type] || 'unknown'
          ic.source_id         = @source.id
          ic.description       = opts[:description] || ''
          ic.interaction_type  = opts[:interaction_type] || ''
          @interaction_claims << ic
        end
      end

      def create_interaction_claim_attribute(opts = {})
        DataModel::InteractionClaimAttribute.new.tap do |ica|
          ica.id            = SecureRandom.uuid
          ica.interaction_claim_id = opts[:interaction_claim_id]
          ica.name          = opts[:name]
          ica.value         = opts[:value]
          @interaction_claim_attributes << ica
        end
      end

      def create_gene_claim(opts = {})
        DataModel::GeneClaim.new.tap do |gc|
          gc.id           = SecureRandom.uuid
          gc.name         = opts[:name]
          gc.nomenclature = opts[:nomenclature]
          gc.source_id    = @source.id
          gc.description  = opts[:description] || ''
          @gene_claims << gc
        end
      end

      def create_drug_claim(opts = {})
        DataModel::DrugClaim.new.tap do |dc|
          dc.id           = SecureRandom.uuid
          dc.name         = opts[:name]
          dc.nomenclature = opts[:nomenclature]
          dc.source_id    = @source.id
          dc.description  = opts[:description] || ''
          dc.primary_name = opts[:primary_name] || ''
          @drug_claims << dc
        end
      end

      def create_drug_claim_alias(opts = {})
        DataModel::DrugClaimAlias.new.tap do |dca|
          dca.id            = SecureRandom.uuid
          dca.drug_claim_id = opts[:drug_claim_id]
          dca.alias         = opts[:alias]
          dca.nomenclature  = opts[:nomenclature]
          dca.description   = ''
          @drug_claim_aliases << dca
        end
      end

      def create_drug_claim_attribute(opts = {})
        DataModel::DrugClaimAttribute.new.tap do |dca|
          dca.id            = SecureRandom.uuid
          dca.drug_claim_id = opts[:drug_claim_id]
          dca.name          = opts[:name]
          dca.value         = opts[:value]
          dca.description   = opts[:description] || ''
          @drug_claim_attributes << dca
        end
      end

      def update_progress(message, percent)
        progress = "=" * (percent/5) unless percent < 5
        printf("\rOverall Import Process: [%-20s] %d%% - %-50s", progress, percent, message)
      end

      def total_entity_count
        @gene_claims.count + @gene_claim_aliases.count +
        @gene_claim_attributes.count + @drug_claims.count + @drug_claim_aliases.count +
        @drug_claim_attributes.count + @interaction_claims.count + @interaction_claim_attributes.count
      end

      def entity_names
        ['gene_claims',
        'gene_claim_aliases',
        'gene_claim_attributes',
        'drug_claims',
        'drug_claim_aliases',
        'drug_claim_attributes',
        'interaction_claims',
        'interaction_claim_attributes']
      end

      def store_entities(item_name, completed_count)
        ivar = instance_variable_get("@#{item_name}")
        klass = "DataModel::#{item_name.classify}".constantize
        if ivar.any?
          update_progress("Storing #{item_name.gsub('_', ' ')}", (completed_count.to_f / total_entity_count) * 100)
          klass.import ivar
          completed_count += ivar.count
          update_progress("Finished storing #{item_name.gsub('_', ' ')}", (completed_count.to_f/total_entity_count) * 100)
        end
        completed_count
      end
    end
  end
end
