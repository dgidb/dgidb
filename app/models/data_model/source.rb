module DataModel
  class Source < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_many :gene_claims, inverse_of: :source
    has_many :drug_claims, inverse_of: :source
    has_many :interaction_claims, inverse_of: :source
    belongs_to :source_type, inverse_of: :sources

    def self.potentially_druggable_sources
      #return source entries for druggable gene sources that aren't Entrez
      #or Ensembl, have genes, and have no interactions
      where(source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE).all
    end

    def self.source_names_with_interactions
      key = 'all_source_names_with_interactions'
      unless Rails.cache.exist?(key)
        Rails.cache.write(key, where(source_type_id: DataModel::SourceType.INTERACTION).pluck(:source_db_name).sort)
      end
      Rails.cache.fetch(key)
    end

  end
end
