class UpdateCkb < ApiUpdater
  def updater
    Genome::OnlineUpdaters::Ckb::Updater.new()
  end

  def next_update_time
    Date.today
      .beginning_of_week
      .next_day(14)
      .midnight
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
