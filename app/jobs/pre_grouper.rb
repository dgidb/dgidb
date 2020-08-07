class PreGrouper < ApplicationJob
  def perform
    normalize_interaction_claim_types
  end

  def normalize_interaction_claim_types
    Genome::Normalizers::InteractionClaimType.normalize_types
  end

end
