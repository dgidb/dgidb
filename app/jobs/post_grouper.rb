#class PostGrouper < ActiveJob::Base
class PostGrouper
  def perform(cleanup_gene_claims = false)
    if cleanup_gene_claims
      delete_orphaned_gene_claims()
    end
    update_counts()
    update_trust_levels()
  end

  def delete_orphaned_gene_claims
      DataModel::GeneClaim.joins(:gene, :gene_claim_aliases, :source)
          .where("gene_claims.gene_id IS NULL and sources.source_db_name = 'Ensembl'")
          .destroy_all
  end

  def update_counts
    Genome::Normalizers::PopulateCounters.populate_source_counters()
  end

  def update_trust_levels
    Genome::Normalizers::SourceTrustLevel.populate_trust_levels()
  end
end
