include Genome::Extensions

class InteractionSearchResultPresenter
  attr_accessor :search_term
  def initialize(interaction, search_term)
    @interaction = interaction
    @search_term = search_term
  end

  def source_db_name
    Maybe(@interaction.citation).source_db_name
  end

  def drug_name
    Maybe(@interaction.drug).name
  end

  def types_string
    @types_string ||= @interaction.types.map{|x| x.value }.join('/')
  end
end

