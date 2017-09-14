class ApiUpdater < Updater
  def perform(recurring = true)
    begin
      import
      grouper = Grouper.new()
      grouper.perform(should_group_genes?, should_group_drugs?)
      post_grouper = PostGrouper.new()
      post_grouper.perform(should_cleanup_gene_claims?)
    ensure
      reschedule if recurring
    end
  end

  def import
    updater.update
  end

  def updater
    raise StandardError.new('Must implement #updater in subclass')
  end
end
