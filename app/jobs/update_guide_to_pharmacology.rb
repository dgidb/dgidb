class UpdateGuideToPharmacology < TsvUpdater
  def tempfile_name
    ['interactions', '.tsv']
  end

  def create_importer
    Genome::Importers::GuideToPharmacologyInteractions::NewGuideToPharmacology.new(tempfile)
  end

  def latest_url
    "http://www.guidetopharmacology.org/DATA/interactions.csv"
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
