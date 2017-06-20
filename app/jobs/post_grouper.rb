#class PostGrouper < ActiveJob::Base
class PostGrouper
  def perform(cleanup_gene_claims = true)
    if cleanup_gene_claims
      delete_orphaned_gene_claims()
    end
    update_counts()
  end

  def delete_orphaned_gene_claims
      DataModel::GeneClaim.joins(:gene, :gene_claim_aliases, :source)
          .where("gene_claims.gene_id IS NULL and sources.source_db_name = 'Ensembl'")
          .each {|c| c.detroy}
  end

  def update_counts
    Genome::Normalizers::PopulateCounters.populate_source_counters()
  end
end
