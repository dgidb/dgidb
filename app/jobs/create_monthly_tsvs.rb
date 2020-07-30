class CreateMonthlyTsvs < ApplicationJob
  def perform
    date = Date.current.strftime("%Y-%b")
    directory = File.join(Rails.root, 'public', 'data', 'monthly_tsvs', date)
    begin
      FileUtils.makedirs(directory)

      puts 'Exporting categories...'
      Utils::TSV.generate_categories_tsv(directory = directory)
      puts 'Exporting interactions...'
      Utils::TSV.generate_interaction_claims_tsv(directory = directory)
      puts 'Exporting genes...'
      Utils::TSV.generate_genes_tsv(directory = directory)
      puts 'Exporting drugs...'
      Utils::TSV.generate_drugs_tsv(directory = directory)
      puts 'Exporting NDEx...'
      Utils::TSV.generate_ndex_interaction_groups_tsv(directory = directory)
    rescue
      FileUtils.rm_rf(directory)
    end
  end
end
