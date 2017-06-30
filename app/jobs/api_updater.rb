class ApiUpdater < Updater
  def perform(recurring = true)
    begin
      updater.update
      reschedule if recurring
      grouper = Grouper.new()
      grouper.perform(should_group_genes?, should_group_drugs?)
      post_grouper = PostGrouper.new()
      post_grouper.perform(should_cleanup_gene_claims?)
    end
  end

  def updater
    raise StandardError.new('Must implement #updater in subclass')
  end
end
