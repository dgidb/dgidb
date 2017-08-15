#class Updater  < ActiveJob::Base
class Updater
  def reschedule
    self.class.set(wait_until: next_update_time).perform_later
  end

  def next_update_time
    raise StandardError.new('Must implement #next_update_time in subclass')
  end

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
