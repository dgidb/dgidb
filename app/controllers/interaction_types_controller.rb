class InteractionTypesController < ApplicationController
  attr_reader :types

  def show
    @types = DataModel::InteractionClaimType.eager_load(interaction_claims: [:source]).order(:type).all
  end
end
