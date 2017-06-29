module FilterHelper
  def construct_filter(params_to_filters_map, params, filter = FilterChain.new)
    params_to_filters_map.each do |param_key, filter_name|
     if should_filter?(param_key, params)
      add_filter(filter, params[param_key], filter_name)
     end
    end
  end

  private
  # this actually adds the filters to the all_include array in a filter_chain object, which will run the filters
  # in my case, I want to get my filter fda_approved_drugs.rb to run, and get a set of interactions (drugs really) that have
  def add_filter(filter, items, filter_name)
    filter.tap do |f|
      Array(items).each do |item|
        f.send(filter_name, item)
      end
    end
  end

  # is it going to be problematic if I don't have a param_to_count_mapping for FDA drugs since it's not really like I'm turning off or on certain types, it's just binary
  def should_filter?(param_value, params)
    if params[param_value] == "checked"
      true
    else 
      !params[param_value].blank? &&
      params[param_value].count != param_to_count_mapping[param_value]
    end
  end

  def param_to_count_mapping
    @@PARAM_TO_COUNT_MAPPING ||= {
      drug_types: DataModel::DrugClaimType.all_type_names.count,
      interaction_sources: DataModel::Source.source_names_with_interactions.count,
      gene_categories: DataModel::GeneClaimCategory.all_category_names.count,
      interaction_types: DataModel::InteractionClaimType.all_type_names.count,
      source_trust_levels: DataModel::SourceTrustLevel.all_trust_levels.count,
      category_sources: DataModel::Source.potentially_druggable_source_names.count,
      fda_approved_drug: -1,
      anti_neoplastic: -1,
      immunotherapy: -1,
      druggable_genome: -1,
      drug_resistance: -1,
      clinically_actionable: -1
    }
  end
end
