class Updater < ApplicationJob
  def should_group_genes?
    raise StandardError.new('Must implement #should_group_genes? in subclass')
  end

  def should_group_drugs?
    raise StandardError.new('Must implement #should_group_drugs? in subclass')
  end

  def should_cleanup_gene_claims?
    false
  end
end
