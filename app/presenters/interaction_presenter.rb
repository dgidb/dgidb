class InteractionPresenter < SimpleDelegator
  attr_accessor :interaction
  
  def initialize(interaction)
    @interaction = interaction
    super
  end

  def display_name
  	"#{@interaction.gene.name} AND #{@interaction.drug.name}"
  end
end