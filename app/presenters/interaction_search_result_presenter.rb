class InteractionSearchResultPresenter
  include Genome::Extensions

  attr_accessor :search_term, :interaction
  def initialize(interaction, search_term)
    @interaction = interaction
    @search_term = search_term
  end

  def source_db_name
    Maybe(@interaction.citation).source_db_name
  end

  def source_db_url
    Maybe(@interaction.citation).site_url
  end

  def drug_name
    Maybe(@interaction.drug).drug_alternate_names.select{|d| d.nomenclature.downcase['primary drug name'] }.first.alternate_name
  end

  def types_string
    @types_string ||= @interaction.types.map{|x| x.value.sub(/^na$/,'n/a') }.join('/')
  end

  def gene_group_name
    Maybe(@interaction.gene).gene_groups.first.name
  end

  def gene_group_display_name
    Maybe(@interaction.gene).gene_groups.first.display_name
  end

  def potentially_druggable_categories
    Maybe(@interaction.gene).gene_groups.first.potentially_druggable_genes.map{|g| g.gene_categories}.flatten.select{|c| c.category_name == 'Human Readable Name'}.map{|c| c.category_value}.uniq
  end
end

