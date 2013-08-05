module FilterHelper
  def construct_filter(params_to_filters_map, params, filter = FilterChain.new)
    params_to_filters_map.each do |param_key, filter_name|
     if should_filter?(param_key, params)
      add_filter(filter, params[param_key], filter_name)
     end
    end
    filter
  end

  private
  def add_filter(filter, items, filter_name)
    filter.tap do |f|
      Array(items).each do |item|
        f.send(filter_name, item)
      end
    end
  end

  def should_filter?(param_value, params)
    !params[param_value].blank? &&
      params[param_value].count != param_to_count_mapping[param_value]
  end

  def param_to_count_mapping
    @@PARAM_TO_COUNT_MAPPING ||= {
      drug_types: DataModel::DrugClaimType.all_type_names.count,
      interaction_sources: DataModel::Source.source_names_with_interactions.count,
      gene_categories: DataModel::GeneClaimCategory.all_category_names.count,
      interaction_types: DataModel::InteractionClaimType.all_type_names.count,
      source_trust_levels: DataModel::SourceTrustLevel.all_trust_levels.count,
      category_sources: DataModel::Source.potentially_druggable_source_names.count
    }
  end
end
