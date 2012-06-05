class GenesController < ApplicationController
  def show
    @title = params[:name]
    @genes = DataModel::Gene.where(name: params[:name])
  end

  def family_search_results
    gene_names = params[:genes].split("\n").collect(&:strip)
    unless params[:geneFile].nil?
      gene_names.concat(params[:geneFile].read.split("\n")).collect(&:strip)
    end
    gene_names.delete_if(&:empty?)
    params[:gene_names] = gene_names

    search_results = LookupInteractions.find(params, :for_gene_families)
    binding.pry
  end
end
