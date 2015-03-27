namespace :dgidb do
  namespace :generate do
    desc 'generate a complete interactions tsv file'
    task interactions_tsv: :environment do
      Utils::TSV.generate_interactions_tsv
    end

    desc 'generate a complete druggable categories tsv file'
    task categories_tsv: :environment do
      Utils::TSV.generate_categories_tsv
    end
  end
end
