class GeneGroupPresenter
  attr_accessor :gene_group
  def initialize(gene_group)
    @gene_group = gene_group
  end

  def display_name
    @gene_group.display_name
  end

  def gene_names
    @uniq_names ||= grouped_names.keys
  end

  def source_db_names
    @uniq_db_names ||= DataSources.uniq_source_names_with_genes.sort_by do |source_db_name|
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
    @grouped_results ||= group_map(@gene_group)
  end

  private
  def group_map(gene_group)
    #make a hash (key=name, value=source_db_names)
    hash = gene_group.genes.inject({}) do |hash, gene|
      source_db_name = gene.citation.source_db_name
      names = gene.gene_alternate_names.map{|a| a.alternate_name} << gene.name
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
