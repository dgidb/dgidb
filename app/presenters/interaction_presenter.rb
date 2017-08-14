class InteractionPresenter < SimpleDelegator
  attr_accessor :interaction
  
  def initialize(interaction)
    @interaction = interaction
    super
  end

  def display_name
  	"#{@interaction.gene.name} AND #{@interaction.drug.name}"
  end

  def na_or_types
    types = interaction.interaction_types.map{|t| t.type}.reject{|t| t == "n/a"}
    types.count > 0 ? types.join(", ") : "n/a"
  end

  def data
    {
      id: interaction.id,
      gene_name: interaction.gene.name,
      drug_name: interaction.drug.name,
      publications: interaction.publications.map(&:pmid),
      interaction_types: interaction.interaction_types.map(&:type),
      sources: interaction.sources.map(&:source_db_name),
    }
  end
end
