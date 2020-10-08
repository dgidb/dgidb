class GenePresenter < SimpleDelegator
  include ApplicationHelper
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
    @uniq_db_names ||= DataModel::Source.source_names_with_gene_claims
  end

  def grouped_names
    @grouped_results ||= group_map(@gene)
  end

  def gene_claims
    @wrapped_claims ||= @gene.gene_claims.map { |gc| GeneClaimPresenter.new(gc) }
  end

  def sorted_claims
    gene_claims.sort_by{ |g| [(g.gene_claim_attributes.empty? ? 1 : 0), (GeneClaimPresenter.new(g).publications.empty? ? 1 : 0), (g.gene_claim_aliases.empty? ? 1 : 0), g.sort_value] }
  end

  def sorted_interactions
    interactions.sort_by{ |i| i.interaction_score }.reverse
  end

  def sorted_interactions_by_score
    interactions.sort_by{ |i| i.interaction_score }.reverse
  end

  def publications
    interactions.map{|i| i.publications}.flatten.uniq
  end

  def as_json(opts = {})
    {
      name: self.display_name,
      long_name: gene.long_name,
      entrez_id: gene.entrez_id,
      aliases: gene.gene_aliases.map(&:alias)
    }
  end

  def flag_icons
    categories = gene_categories.map{|category| category.name}

    flags = []
    if categories.include? "DRUGGABLE GENOME"
      flags = flags.push(["Druggable Genome", "warning"])
    end
    if categories.include? "CLINICALLY ACTIONABLE"
      flags = flags.push(["Clinically Actionable","primary"])
    end
    if categories.include? "DRUG RESISTANCE"
      flags = flags.push(["Drug Resistance", "default"])
    end
    flag_help(flags)
  end

  private
  def group_map(gene)
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
