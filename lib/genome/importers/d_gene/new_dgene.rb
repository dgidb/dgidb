require 'genome/online_updater'

module Genome; module Importers; module DGene;
  class NewDGene < Genome::OnlineUpdater
    attr_reader :file_path
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_new_source
      create_gene_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('dGene')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
          {
              base_url:          'http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980',
              site_url:          'http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980',
              citation:          'Prioritizing Potentially Druggable Mutations with dGene: An Annotation Tool for Cancer Genome Sequencing Data. Kumar RD, Chang LW, Ellis MJ, Bose R. PLoS One. 2013 Jun 27;8(6):e67980. PMID: 23826350.',
              source_db_version: '27-Jun-2013',
              source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
              source_db_name:    'dGene',
              full_name:         'dGENE - The Druggable Gene List',
              license_link:      'https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980#pone.0067980.s002',
              license:           'Creative Commons Attribution License (Version not specified)'
          }
      )
    end
    
    def create_gene_claims
      CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
    end
  end
end;end;end
