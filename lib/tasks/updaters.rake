namespace :dgidb do
  namespace :update do
    desc 'Update CIViC'
    task civic: :environment do
      civic = Genome::Updaters::GetCivic.new()
      if !civic.is_current?
        civic.to_tsv
        if DataModel::Source.where('lower(sources.source_db_name) = ?', 'civic').any?
          Utils::Database.delete_source('CIViC')
        end
        Genome::Importers::Civic.run(civic.default_savefile, civic.new_version)
      end
    end

    desc 'Update DoCM'
    task docm: :environment do
      docm = Genome::Updaters::GetDocm.new()
      if !docm.is_current?
        docm.to_tsv
        if DataModel::Source.where('lower(sources.source_db_name) = ?', 'docm').any?
          Utils::Database.delete_source('DoCM')
        end
        Genome::Importers::Docm.run(docm.default_savefile, docm.new_version)
      end
    end

    # desc 'generate a complete druggable categories tsv file'
    # task categories_tsv: :environment do
    #   Utils::TSV.generate_categories_tsv
    # end
  end
end
