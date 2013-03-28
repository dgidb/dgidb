#HERE BE DRAGONS
module Genome
  module Importers
    class Importer
      def initialize(source_info)
        entity_names.each { |entity| instance_variable_set("@#{entity}", {}) }
        @source = create_source(source_info)
      end

      def store
        ActiveRecord::Base.transaction do
          @source.save
          entity_names.each { |entity| store_entities(entity) }
        end
      end

      #create_gene_claim_alias will add a new hash to gene_claim_aliases
      def method_missing(meth, *args)
        super unless match_data = meth.to_s.match(/create_(?<entity_name>.+)/)
        add_entity_by_name(match_data['entity_name'], args.first)
      end

      private
      def add_entity_by_name(entity_name, attrs)
        entities = instance_variable_get("@#{entity_name.pluralize}")
        key = attrs.hash
        if entities.include?(key)
          entities[key][:id]
        else
          prepare_new_entity(attrs,key, entities)
        end
      end

      def prepare_new_entity(attrs, key, entities)
        if existing = attrs[:id]
          entities[key] = attrs
          existing
        else
          SecureRandom.uuid.tap do |new_id|
            attrs[:id] = new_id
            entities[key] = attrs
          end
        end
      end

      def create_source(source_info)
        source_info[:id] = SecureRandom.uuid
        create_entity_from_hash(DataModel::Source, source_info)
      end

      def create_entity_from_hash(klass, hash)
        klass.new.tap { |o| o.assign_attributes(hash, without_protection: true) }
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

      def create_models_from_hashes(entity_name)
        hashes = instance_variable_get("@#{entity_name}").values
        klass = class_from_entity(entity_name)
        has_source = has_source?(klass)
        hashes.map do |hash|
          hash[:source_id] = @source.id if has_source
          create_entity_from_hash(klass, hash)
        end
      end

      def store_entities(item_name)
        objs = create_models_from_hashes(item_name)
        klass = class_from_entity(item_name)
        klass.import(objs) if objs.any?
      end

      def has_source?(klass)
        klass.new.attributes.key?("source_id")
      end

      def class_from_entity(entity)
        "DataModel::#{entity.classify}".constantize
      end
    end
  end
end
