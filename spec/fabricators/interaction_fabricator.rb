Fabricator(:interaction_claim, class_name: 'DataModel::InteractionClaim') do
  source
  drug_claim { |attrs| Fabricate(:drug_claim, source: attrs[:source]) }
  gene_claim { |attrs| Fabricate(:gene_claim, source: attrs[:source]) }
  interaction_type ''
  description ''
  known_action_type { ['known', 'unknown', 'n/a'].sample }
end

Fabricator(:interaction_claim_type, class_name: 'DataModel::InteractionClaimType') do
  type { ['inhibitor', 'n/a', 'antagonist', 'multitarget'].sample }
end
