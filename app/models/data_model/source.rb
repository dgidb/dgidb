module DataModel
  class Source < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_many :gene_claims, inverse_of: :source
    has_many :drug_claims, inverse_of: :source
    has_many :interaction_claims, inverse_of: :source

    def self.potentially_druggable_sources
      #return source entries for druggable gene sources that aren't Entrez
      #or Ensembl, have genes, and have no interactions
      DataModel::Source.where('source_db_name not in (?)', ['Entrez', 'Ensembl']).
        select{ |c| c.gene_claims.any? }.reject{|c| c.interaction_claims.any? }
    end
  end
end
