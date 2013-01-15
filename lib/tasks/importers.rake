namespace :dgidb do
  namespace :import do

    desc 'import DrugBank from a TSV file'
    task :drug_bank, [:drug_bank_tsv_path, :source_db_version, :uniprot_mapping_file] => :environment do |t, args|
      Genome::Importers::DrugBank::DrugBankImporter.new(args[:drug_bank_tsv_path], args[:source_db_version], args[:uniprot_mapping_file]).import!
    end

    desc 'import dGene from a TSV file'
    task :dgene, [:dgene_tsv_path, :source_db_version] => :environment do |t, args|
      Genome::Importers::DGene::DGeneImporter.new(args[:dgene_tsv_path], args[:source_db_version]).import!
    end

    desc 'import Ensembl from a TSV file'
    task :ensembl, [:ensembl_tsv_path, :source_db_version] => :environment do |t, args|
      Genome::Importers::Ensembl::EnsemblImporter.new(args[:ensembl_tsv_path], args[:source_db_version]).import!
    end

  end
end
