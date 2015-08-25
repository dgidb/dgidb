namespace :dgidb do
  namespace :import do

    # Rake tasks will be automatically generated if you put your TSV importers under
    # lib/genome/importers/<source_name>
    # A file in that directory should define a module named Genome::Importers::SourceName
    # that responds to a method run() that takes a single argument - the path to the tsv file

    importer_path = File.join(Rails.root, 'lib/genome/importers/*/')
    #ignore the DSL files
    Dir.glob(importer_path).reject { |path| path =~ /dsl\/$/ }.each do |importer|
      importer_dir = File.basename(importer)
      importer_name = importer_dir.camelize
      send(:desc, "Import #{importer_dir} from a provided tsv file. If the source already exists, it will be overwritten!")
      send(:task, importer_dir.to_sym, [:tsv_path, :gene_group, :drug_group] => :environment) do |_, args|
        importer_class = if Genome::Importers.const_defined?(importer_name)
                           "Genome::Importers::#{importer_name}".constantize
                         else
                           "Genome::Importers::#{importer_name.camelize}".constantize
                         end
          if DataModel::Source.where('lower(sources.source_db_name) = ?', importer_name.downcase).any?
            puts 'Found existing source! Deleting...'
            Utils::Database.delete_source(importer_name)
          end

          puts 'Starting import!'
          importer_class.run(args[:tsv_path])

          if args[:gene_group] == 'true'
            puts 'Running Gene Grouper - this takes awhile!'
            Genome::Groupers::GeneGrouper.run
          end

          if args[:drug_group] == 'true'
            puts 'Running Drug Grouper - this takes awhile!'
            Genome::Groupers::DrugGrouper.run
          end

          puts 'Populating source counters.'
          Genome::Normalizers::PopulateCounters.populate_source_counters
          puts 'Attempting to normalize drug types.'
          Genome::Normalizers::DrugTypeNormalizers.normalize_types
          puts 'Filling in source trust levels'
          Genome::Normalizers::SourceTrustLevel.populate_trust_levels
          puts 'Attempting to normalize interaction types'
          Genome::Normalizers::InteractionClaimType.normalize_types
          puts 'Clearing cache'
          Rails.cache.clear
          puts 'Done.'
      end
    end

    desc 'import Entrez gene pathway information from a TSV file'
    task :entrez_pathway, [:tsv_path] => :environment do |t, args|
      Genome::Importers::EntrezGenePathway::EntrezGenePathwayImporter.new(args[:tsv_path])
        .import!
    end
  end
end
