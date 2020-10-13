class UpdateCivic < ApiUpdater
  def create_updater
    Genome::OnlineUpdaters::Civic::Updater.new()
  end

  def should_group_genes?
    true
  end

  def should_group_drugs?
    true
  end

  def should_cleanup_gene_claims?
    false
  end
end
