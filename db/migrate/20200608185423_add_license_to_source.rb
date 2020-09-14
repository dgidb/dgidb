class AddLicenseToSource < ActiveRecord::Migration[6.0]
  def up
    add_column :sources, :license, :string
    add_column :sources, :license_link, :string

    s = DataModel::Source.find_by(source_db_name: "BaderLabGenes")
    s.license = 'Supplemental data from CC-BY 3.0 arXiv preprint'
    s.license_link = 'http://baderlab.org/Data/RoadsNotTaken'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CGI")
    s.license = 'Creative Commons Attribution-NonCommercial 4.0 (BY-NC)'
    s.license_link = 'https://www.cancergenomeinterpreter.org/faq#q11c'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CIViC")
    s.license = 'Creative Commons Public Domain Dedication (CC0 1.0 Universal)'
    s.license_link = 'https://docs.civicdb.org/en/latest/about/faq.html#how-is-civic-licensed'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CKB")
    s.license = 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License'
    s.license_link = 'https://ckb.jax.org/about/index'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CancerCommons")
    s.license = 'Custom non-commercial'
    s.license_link = 'https://www.cancercommons.org/terms-of-use/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CarisMolecularIntelligence")
    s.license = 'Unknown; data is no longer publicly available from site'
    s.license_link = 'https://www.carismolecularintelligence.com/contact-us/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "ChemblDrugs")
    s.license = 'Creative Commons Attribution-Share Alike 3.0 Unported License'
    s.license_link = 'https://chembl.gitbook.io/chembl-interface-documentation/about'
    s.save
    s = DataModel::Source.find_by(source_db_name: "ChemblInteractions")
    s.license = 'Creative Commons Attribution-Share Alike 3.0 Unported License'
    s.license_link = 'https://chembl.gitbook.io/chembl-interface-documentation/about'
    s.save
    s = DataModel::Source.find_by(source_db_name: "ClearityFoundationBiomarkers")
    s.license = 'Unknown; data is no longer publicly available from site'
    s.license_link = 'https://www.clearityfoundation.org/about-clearity/contact/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "ClearityFoundationClinicalTrial")
    s.license = 'Unknown; data is no longer publicly available from site'
    s.license_link = 'https://www.clearityfoundation.org/about-clearity/contact/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "DoCM")
    s.license = 'Creative Commons Attribution 4.0 International License'
    s.license_link = 'http://www.docm.info/about'
    s.save
    s = DataModel::Source.find_by(source_db_name: "DrugBank")
    s.license = 'Custom non-commercial'
    s.license_link = 'https://dev.drugbankplus.com/guides/drugbank/citing?_ga=2.29505343.1251048939.1591976592-781844916.1591645816'
    s.save
    s = DataModel::Source.find_by(source_db_name: "Ensembl")
    s.license = 'Unrestricted license, pass-through constraints'
    s.license_link = 'https://useast.ensembl.org/info/about/legal/disclaimer.html'
    s.save
    s = DataModel::Source.find_by(source_db_name: "Entrez")
    s.license = 'Unrestricted license, pass-through constraints'
    s.license_link = 'https://www.nlm.nih.gov/accessibility.html'
    s.save
    s = DataModel::Source.find_by(source_db_name: "FDA")
    s.license = 'Public Domain'
    s.license_link = 'https://www.fda.gov/about-fda/about-website/website-policies#linking'
    s.save
    s = DataModel::Source.find_by(source_db_name: "FoundationOneGenes")
    s.license = 'Unknown; data is no longer publicly available from site'
    s.license_link = 'https://www.foundationmedicine.com/resource/legal-and-privacy'
    s.save
    s = DataModel::Source.find_by(source_db_name: "GO")
    s.license = 'Creative Commons Attribution 4.0 Unported License'
    s.license_link = 'http://geneontology.org/docs/go-citation-policy/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "GuideToPharmacologyGenes")
    s.license = 'Creative Commons Attribution-ShareAlike 4.0 International License'
    s.license_link = 'https://www.guidetopharmacology.org/about.jsp'
    s.save
    s = DataModel::Source.find_by(source_db_name: "GuideToPharmacologyInteractions")
    s.license = 'Creative Commons Attribution-ShareAlike 4.0 International License'
    s.license_link = 'https://www.guidetopharmacology.org/about.jsp'
    s.save
    s = DataModel::Source.find_by(source_db_name: "HingoraniCasas")
    s.license = 'Supplementary data from Author Copyright publication'
    s.license_link = 'https://stm.sciencemag.org/content/9/383/eaag1166/tab-pdf'
    s.save
    s = DataModel::Source.find_by(source_db_name: "HopkinsGroom")
    s.license = 'Supplementary data from Nature Publishing Group copyright publication'
    s.license_link = 'https://www.nature.com/articles/nrd892'
    s.save
    s = DataModel::Source.find_by(source_db_name: "MskImpact")
    s.license = 'Supplementary data from American Society for Investigative Pathology and the Association for Molecular Pathology copyright publication'
    s.license_link = 'https://jmd.amjpathol.org/action/showPdf?pii=S1525-1578%2815%2900045-8'
    s.save
    s = DataModel::Source.find_by(source_db_name: "MyCancerGenome")
    s.license = 'Restrictive, custom, non-commercial'
    s.license_link = 'https://www.mycancergenome.org/content/page/legal-policies-licensing/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "MyCancerGenomeClinicalTrial")
    s.license = 'Restrictive, custom, non-commercial'
    s.license_link = 'https://www.mycancergenome.org/content/page/legal-policies-licensing/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "NCI")
    s.license = 'Public domain'
    s.license_link = 'https://www.cancer.gov/policies/copyright-reuse'
    s.save
    s = DataModel::Source.find_by(source_db_name: "OncoKB")
    s.license = 'Restrictive, non-commercial'
    s.license_link = 'https://www.oncokb.org/terms'
    s.save
    s = DataModel::Source.find_by(source_db_name: "PharmGKB")
    s.license = 'Creative Commons Attribution-ShareAlike 4.0 International License'
    s.license_link = 'https://www.pharmgkb.org/page/faqs'
    s.save
    s = DataModel::Source.find_by(source_db_name: "PubChem")
    s.license = 'Public domain'
    s.license_link = 'https://pubchemdocs.ncbi.nlm.nih.gov/downloads'
    s.save
    s = DataModel::Source.find_by(source_db_name: "RussLampel")
    s.license = 'Unknown; data is no longer publicly available from external site, referenced in Elsevier copyright publication'
    s.license_link = 'https://www.sciencedirect.com/science/article/pii/S1359644605036664'
    s.save
    s = DataModel::Source.find_by(source_db_name: "TALC")
    s.license = 'Data extracted from tables in Elsevier copyright publication'
    s.license_link = 'https://www.sciencedirect.com/science/article/pii/S1525730413002350'
    s.save
    s = DataModel::Source.find_by(source_db_name: "TEND")
    s.license = 'Supplementary table from Macmillan Publishers Limited copyright publication'
    s.license_link = 'https://www.nature.com/articles/nrd3478'
    s.save
    s = DataModel::Source.find_by(source_db_name: "TTD")
    s.license = 'Unclear. Website states "All Rights Reserved" but resource structure and description in 2002 publication indicate "open-access".'
    s.license_link = 'https://academic.oup.com/nar/article/30/1/412/1331814'
    s.save
    s = DataModel::Source.find_by(source_db_name: "TdgClinicalTrial")
    s.license = 'Supplementary table from Annual Reviews copyright publication'
    s.license_link = 'https://www.annualreviews.org/doi/10.1146/annurev-pharmtox-011613-135943?url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org&rfr_dat=cr_pub++0pubmed'
    s.save
    s = DataModel::Source.find_by(source_db_name: "dGene")
    s.license = 'Creative Commons Attribution License (Version not specified)'
    s.license_link = 'https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980#pone.0067980.s002'
    s.save
  end

  def down
    remove_column :sources, :license
    remove_column :sources, :license_link
  end
end
