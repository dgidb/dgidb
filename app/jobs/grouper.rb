class Grouper < ApplicationJob
  def perform(group_genes = true, group_drugs = true)
      if group_genes
        gene_grouper = Genome::Groupers::GeneGrouper.new()
        gene_grouper.run()
      end
      if group_drugs
        drug_grouper = Genome::Groupers::DrugGrouper.new()
        drug_grouper.run()
      end
      Genome::Groupers::InteractionGrouper.run()
  end
end
