require 'rake'
Rails.application.load_tasks
class PostGrouper < ApplicationJob
  def perform(cleanup_gene_claims = false)
    if cleanup_gene_claims
      delete_orphaned_gene_claims
    end
    update_counts
    update_trust_levels
    update_drug_types
    backfill_publications
    Rails.cache.clear
    Rake::Task['dgidb:dump_local'].execute
  end

  def delete_orphaned_gene_claims
      DataModel::GeneClaim.joins(:gene, :gene_claim_aliases, :source)
          .where("gene_claims.gene_id IS NULL and sources.source_db_name = 'Ensembl'")
          .destroy_all
  end

  def update_counts
    Genome::Normalizers::PopulateCounters.populate_source_counters
  end

  def update_trust_levels
    Genome::Normalizers::SourceTrustLevel.populate_trust_levels
  end

  def update_drug_types
    Genome::Normalizers::DrugTypeNormalizer.normalize_types
  end

  def backfill_publications
    Genome::Normalizers::Publications.populate_interaction_claims
  end
end
