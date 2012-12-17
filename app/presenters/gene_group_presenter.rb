class GeneGroupPresenter
  attr_accessor :gene
  def initialize(gene)
    @gene = gene
  end

  def display_name
    @gene.display_name
  end

  def gene_claim_names
    @uniq_names ||= grouped_names.keys
  end

  def source_db_names
    @uniq_db_names ||= DataSources.uniq_source_names_with_gene_claims.sort_by do |source_db_name|
      case source_db_name
      when 'Entrez'
        -2
      when 'Ensembl'
        -1
      else
        0
      end
    end
  end

  def grouped_names
    @grouped_results ||= group_map(@gene)
  end

  private
  def group_map(gene)
    #make a hash (key=name, value=source_db_names)
    hash = gene.gene_claims.inject({}) do |hash, gene_claim|
      source_db_name = gene_claim.source.source_db_name
      names = gene_claim.gene_claim_aliases.map{|a| a.alias} << gene_claim.name
      names.each do |name|
        hash[name] ||= Hash.new {|key, val| false}
        hash[name][source_db_name] = true
      end
      hash
    end

    results = []
    hash.each_pair do |key, value|
      results << GeneGroupNamePresenter.new(key, value, source_db_names)
    end
    results
  end

end
