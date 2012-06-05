class DataModel::Interaction < ActiveRecord::Base
    self.table_name = 'drug_gene_interaction_report'
    belongs_to :gene, foreign_key: :gene_name_report_id
    belongs_to :drug, foreign_key: :drug_name_report_id
    has_many :interaction_attributes
    belongs_to :citation

    def types
      self.interaction_attributes.find_all{|attribute| attribute.name == 'interaction_type'}
    end

    def attributes
      self.interaction_attributes.find_all{|attribute| attribute.name != 'interaction_type'}
    end

    def self.attribute(name, val)
      DataModel::Interaction.joins{interaction_attributes}.where{
        (interaction_attributes.name.eq(name) & interaction_attributes.value.eq(val))
      }.select{id}
    end

    def self.drug_category(*val)
      DataModel::Drug.joins{drug_categories}.where{
        drug_categories.category_value.like_any(val)
      }.select{id}
    end

    def self.gene_name_alternate(val)
      DataModel::Gene.joins{ gene_alternate_names }.where{
        gene_alternate_names.alternate_name.like(val)
      }
    end

    def self.source_scope(opts)
      filters = opts.select{|key, val| val == '1'}.keys
      memoize_query(DataModel::Interaction.joins{citation}.where{
        citation.source_db_name.like_any(filters)
      }.select{id}, "source_filter_#{filters.join("_")}")
    end

    def self.basic
    #'drug.is_withdrawn=0,drug.is_nutraceutical=0,is_potentiator=0,(is_untyped=0 or is_known_action=1)' if /default/;
      memoize_query(DataModel::Interaction.joins{drug}.where{
          id.not_in(my{attribute("interaction_type", "potentiator")}) &
          ( id.not_in(my{attribute("interaction_type", "na")}) | id.in( my{attribute("is_known_action", "yes" )}) ) &
          drug.id.not_in(my{drug_category("withdrawn","nutraceutical")})
        }.select{id}, "interaction_filter_basic")
    end

    def self.inhibitors_only
    #'drug.is_withdrawn=0,drug.is_nutraceutical=0,is_potentiator=0,is_inhibitor=1,(is_untyped=0 or is_known_action=1)';
      memoize_query(DataModel::Interaction.joins{drug}.where{
        id.not_in(my{attribute("interaction_type", "potentiator")}) &
        id.in(my{attribute("interaction_type", "inhibitor")}) &
        ( id.not_in(my{attribute("interaction_type", "na")}) | id.in( my{attribute("is_known_action", "yes" )}) ) &
        drug.id.not_in(my{drug_category("withdrawn","nutraceutical")})
      }.select{id}, "interaction_filter_inhibitors")
    end

    def self.kinase_only
    #'drug.is_withdrawn=0,drug.is_nutraceutical=0,is_potentiator=0,gene.is_kinase=1,(is_untyped=0 or is_known_action=1)'
      memoize_query(DataModel::Interaction.joins{drug}.joins{gene}.where{
        id.not_in(my{attribute("interaction_type", "potentiator")}) &
        ( id.not_in(my{attribute("interaction_type", "na")}) | id.in( my{attribute("is_known_action", "yes" )}) ) &
        drug.id.not_in(my{drug_category("withdrawn","nutraceutical")}) &
        gene.id.in(my{gene_name_alternate("%kinase%")})
      }.select{id}, "interaction_filter_kinase")
    end

    def self.anti_neoplastic
    #'drug.is_withdrawn=0,drug.is_nutraceutical=0,is_potentiator=0,drug.is_antineoplastic=1,(is_untyped=0 or is_known_action=1)'
      memoize_query(DataModel::Interaction.joins{drug}.joins{gene}.where{
        id.not_in(my{attribute("interaction_type", "potentiator")}) &
        drug.id.in(my{drug_category("%antineoplastic%")}) &
        ( id.not_in(my{attribute("interaction_type", "na")}) | id.in( my{attribute("is_known_action", "yes" )}) ) &
        drug.id.not_in(my{drug_category("withdrawn","nutraceutical")})
      }.select{id}, "interaction_filter_anti_neoplastic")
    end

    def self.none
      memoize_query(DataModel::Interaction.where{true}, "interaction_filter_none")
    end

    private
    def self.memoize_query(query,cache_key)
      if Rails.cache.exist?(cache_key)
        Rails.cache.fetch(cache_key)
      else
        filter = query.inject({}) do |hash,val|
          hash[val.id] = true
          hash
        end
        Rails.cache.write(cache_key, filter, expires_in: 6.hours)
        filter
      end
    end
end
