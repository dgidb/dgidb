class InteractionTypesController < ApplicationController
  attr_reader :types

  def show
    @types = DataModel::InteractionClaimType.eager_load(interactions: [:sources]).order(:type).all
  end
end
