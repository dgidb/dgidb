class InteractionPresenter < SimpleDelegator
	# straight from gene.. doesnt make sense
  attr_accessor :interaction
  def initialize(interaction)
    @interaction = interaction
    super
  end
end