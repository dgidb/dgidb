def count_initializer(source_types)
  ->(attrs) { source_types.include?(attrs[:source_types].first.type) ? rand(1000) : 0 }
end

Fabricator(:source, class_name: 'DataModel::Source') do
  source_types { [ Fabricate(:source_type) ] }
  source_trust_level
  source_db_name { sequence(:source_db_name) { |i| "Source##{i}" } }
  source_db_version { sequence(:source_db_version) { |i| "db version string for source#{i}" } }
  citation { sequence(:citation) { |i| "This is the citation text for source number #{i}" } }
  base_url { sequence(:base_url) { |i| "http://www.source.com/?entity_id#{i}=" } }
  site_url { sequence(:site_url) { |i| "http://www.mypublication.com/#{i}" } }
  full_name { sequence(:full_name) { |i| "source full name, long form ##{i}" } }
  gene_claims_count { |attrs| count_initializer(%{gene interaction potentially_druggable}).call(attrs) }
  drug_claims_count { |attrs| count_initializer(%{drug interaction}).call(attrs) }
  interaction_claims_count { |attrs| count_initializer(%{interaction}).call(attrs) }
  interaction_claims_in_groups_count { |attrs| rand(attrs[:interaction_claims_count]) }
  gene_claims_in_groups_count { |attrs| rand(attrs[:gene_claims_count]) }
  drug_claims_in_groups_count { |attrs| rand(attrs[:drug_claims_count]) }
end

Fabricator(:source_type, class_name: 'DataModel::SourceType') do
  type { %w{gene drug interaction potentially_druggable}.sample }
end

Fabricator(:source_trust_level, class_name: 'DataModel::SourceTrustLevel') do
  level { ['Expert curated', 'Non-curated'].sample }
end
