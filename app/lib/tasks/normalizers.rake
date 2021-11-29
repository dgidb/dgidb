namespace :dgidb do
  namespace :normalize do

    desc 'normalize drug claim types up into table from hangoff properties'
    task drug_claim_types: :environment do
      Genome::Normalizers::DrugTypeNormalizers.normalize_types
    end

    desc 'initially populate counter cache columns for sources'
    task populate_source_counters: :environment do
      Genome::Normalizers::PopulateCounters.populate_source_counters
    end

    desc 'initialize the source trust level enum and set values for sources'
    task initialize_trust_levels_for_sources: :environment do
      Genome::Normalizers::SourceTrustLevel.populate_trust_levels
    end

    desc 'populate interaction type values for interactions`'
    task initialize_trust_levels_for_sources: :environment do
      Genome::Normalizers::InteractionClaimType.normalize_types
    end

    desc 'get citations from PMIDs'
    task publications: :environment do
      Genome::Normalizers::Publications.populate_interaction_claims
    end
  end
end
