#class Grouper < ActiveJob::Base
class Grouper
  def perform(group_genes = true, group_drugs = true)
      if group_genes
        gene_grouper = Genome::Groupers::GeneGrouper.new()
        gene_grouper.run()
      end
      if group_drugs
        Genome::Groupers::DrugGrouper.run()
      end
      Genome::Groupers::InteractionGrouper.run()
  end
end
