class UpdateCivic < ApiUpdater
  def updater
    return Genome::OnlineUpdaters::Civic::Updater.new()
  end

  def next_update_time
    Date.today
      .beginning_of_week
      .next_day(14)
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
