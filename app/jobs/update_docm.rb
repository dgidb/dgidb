class UpdateDocm < ApiUpdater
  def updater
    return Genome::OnlineUpdaters::Docm::Updater.new()
  end

  def next_update_time
    Date.today
      .beginning_of_week
      .next_month
      .midnight
  end

  def should_group_genes?
    return true
  end

  def should_group_drugs?
    return true
  end

  def should_cleanup_gene_claims?
    return false
  end
end
