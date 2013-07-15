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

    desc 'import Entrez from a TSV file'
    task :entrez, [:entrez_tsv_path, :source_db_version] => :environment do |t, args|
      Genome::Importers::Entrez::EntrezImporter.new(args[:entrez_tsv_path], args[:source_db_version]).import!
    end

    desc 'import HopkinsGroom from a TSV file'
    task :hopkins_groom, [:hg_tsv_path, :source_db_version] => :environment do |t, args|
      Genome::Importers::HopkinsGroom::HopkinsGroomImporter.new(args[:hg_tsv_path], args[:source_db_version]).import!
    end

    desc 'import MyCancerGenome from a TSV file'
    task :my_cancer_genome, [:mcg_tsv_path] => :environment do |t, args|
      Genome::Importers::MyCancerGenome.run(args[:mcg_tsv_path])
    end

    desc 'import CancerCommons from a TSV file'
    task :cancer_commons, [:tsv_path] => :environment do |t, args|
      Genome::Importers::CancerCommons.run(args[:tsv_path])
    end

    desc 'import PharmGKB from a TSV file'
    task :pharmgkb, [:pharmgkb_tsv_path] => :environment do |t, args|
      Genome::Importers::Pharmgkb.run(args[:pharmgkb_tsv_path])    
    end

    #desc 'import RussLampel from a TSV file'
    #task :russ_lampel, [:russ_lampel_path] => :environment do |t, args|
    #  Genome::Importers::RussLampel.run(args[:russ_lampel_path])
    #end

    desc 'import TALC from a TSV file'
    task :talc, [:talc_path] => :environment do |t, args|
      Genome::Importers::Talc.run(args[:talc_path])
    end

    desc 'import TEND from a TSV file'
    task :tend, [:tend_path] => :environment do |t, args|
      Genome::Importers::Tend.run(args[:tend_path])
    end

    desc 'import TTD from a TSV file'
    task :ttd, [:ttd_path] => :environment do |t, args| 
      Genome::Importers::TTD.run(args[:ttd_path])
    end
  end
end
