module DataModel
  class Citation < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'citation'
    has_many :genes, inverse_of: :citation
    has_many :drugs, inverse_of: :citation
    has_many :interactions, inverse_of: :citation

    def self.potentially_druggable_sources
      #return citations for druggable gene sources that aren't Entrez or Ensembl, have genes, and have no interactions
      DataModel::Citation.where('source_db_name not in (?)', ['Entrez', 'Ensembl']).select{|c| c.genes.any?}.reject{|c| c.interactions.any?}
    end
  end
end
