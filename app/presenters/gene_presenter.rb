class GenePresenter < SimpleDelegator
  attr_accessor :gene
  def initialize(gene)
    @gene = gene
    super
  end

  def display_name
    name
  end

  def gene_claim_names
    @uniq_names ||= grouped_names.keys
  end

  def source_db_names
    @uniq_db_names ||= DataSources.gene_sources_in_display_order
  end

  def grouped_names
    @grouped_results ||= group_map(@gene)
  end

  def gene_claims
    @wrapped_claims ||= @gene.gene_claims.map { |gc| GeneClaimPresenter.new(gc) }
  end

  private
  def group_map(gene)
    #make a hash (key=name, value=source_db_names)
    hash = gene_claims.each_with_object({}) do |gene_claim, h|
      source_db_name = gene_claim.source.source_db_name
      names = gene_claim.gene_claim_aliases.map{|a| a.alias} << gene_claim.name
      names.each do |name|
        h[name] ||= Hash.new {|key, val| false}
        h[name][source_db_name] = true
      end
    end

    [].tap do |results|
      hash.each_pair do |key, value|
        results << GeneNamePresenter.new(key, value, source_db_names)
      end
    end
  end

end
