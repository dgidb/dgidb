namespace :dgidb do
  namespace :group do
    desc 'run the gene grouper'
    task genes: :environment do
      Utils::Logging::without_sql do
        Genome::Groupers::GeneGrouper.run
      end
    end
    desc 'run the drug grouper'
    task drugs: :environment do
      Utils::Logging::without_sql do
        Genome::Groupers::DrugGrouper.run
      end
    end
    desc 'run the interaction grouper'
    task interactions: :environment do
      Utils::Logging::without_sql do
        Genome::Groupers::InteractionGrouper.run
      end
    end
  end
end
