namespace :dgidb do
  namespace :group do
    desc 'run the gene grouper'
    task genes: :environment do
      Utils::Logging::without_sql do
        Genome::Groupers::GeneGrouper.run
      end
    end
  end
end
