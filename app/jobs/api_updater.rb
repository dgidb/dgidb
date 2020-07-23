class ApiUpdater < Updater
  def perform()
    import
    pre_grouper = PreGrouper.new
    pre_grouper.perform
    grouper = Grouper.new
    grouper.perform(should_group_genes?, should_group_drugs?)
    post_grouper = PostGrouper.new
    post_grouper.perform(should_cleanup_gene_claims?)
  end

  def import
    updater.update
  end

  def updater
    raise StandardError.new('Must implement #updater in subclass')
  end
end
