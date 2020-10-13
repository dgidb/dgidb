class ApiUpdater < Updater
  attr_reader :updater

  def perform()
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      import
      pre_grouper = PreGrouper.new
      pre_grouper.perform
      grouper = Grouper.new
      grouper.perform(should_group_genes?, should_group_drugs?, updater.source.id)
      post_grouper = PostGrouper.new
      post_grouper.perform(should_cleanup_gene_claims?)
    end
  end

  def import
    @updater = create_updater
    updater.update
  end

  def create_updater
    raise StandardError.new('Must implement #create_updater in subclass')
  end
end
