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

  end
end
