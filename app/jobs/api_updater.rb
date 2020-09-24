class ApiUpdater < Updater
  attr_reader :importer

  def perform()
    import
    pre_grouper = PreGrouper.new
    pre_grouper.perform
    grouper = Grouper.new
    grouper.perform(should_group_genes?, should_group_drugs?, importer.source.id)
    post_grouper = PostGrouper.new
    post_grouper.perform(should_cleanup_gene_claims?)
  end

  def import
    @importer = create_importer
    importer.import
  end

  def create_importer
    raise StandardError.new('Must implement #create_importer in subclass')
  end
end
