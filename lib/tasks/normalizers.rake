namespace :dgidb do
  namespace :normalize do

    desc 'normalize drug claim types up into table from hangoff properties'
    task drug_claim_types: :environment do
      Genome::Normalizers::DrugTypeNormalizers.normalize_types
    end

  end
end
