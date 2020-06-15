class AddLicenseToSource < ActiveRecord::Migration[6.0]
  def up
    add_column :sources, :license, :string
    add_column :sources, :license_link, :string

    s = DataModel::Source.find_by(source_db_name: "BaderLabGenes")
    s.license = ''
    s.license_link = ''
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
    s.license = ''
    s.license_link = 'https://www.cancercommons.org/terms-of-use/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "CarisMolecularIntelligence")
    s.license = ''
    s.license_link = ''
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
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "ClearityFoundationClinicalTrial")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "DoCM")
    s.license = 'Creative Commons Attribution 4.0 International License'
    s.license_link = 'http://www.docm.info/about'
    s.save
    s = DataModel::Source.find_by(source_db_name: "DrugBank")
    s.license = ''
    s.license_link = 'https://dev.drugbankplus.com/guides/drugbank/citing?_ga=2.29505343.1251048939.1591976592-781844916.1591645816'
    s.save
    s = DataModel::Source.find_by(source_db_name: "Ensembl")
    s.license = ''
    s.license_link = 'https://useast.ensembl.org/info/about/legal/disclaimer.html'
    s.save
    s = DataModel::Source.find_by(source_db_name: "Entrez")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "FDA")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "FoundationOneGenes")
    s.license = ''
    s.license_link = ''
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
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "HopkinsGroom")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "MskImpact")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "MyCancerGenome")
    s.license = ''
    s.license_link = 'https://www.mycancergenome.org/content/page/legal-policies-licensing/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "MyCancerGenomeClinicalTrial")
    s.license = ''
    s.license_link = 'https://www.mycancergenome.org/content/page/legal-policies-licensing/'
    s.save
    s = DataModel::Source.find_by(source_db_name: "NCI")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "OncoKB")
    s.license = ''
    s.license_link = 'https://www.oncokb.org/terms'
    s.save
    s = DataModel::Source.find_by(source_db_name: "PharmGKB")
    s.license = 'Creative Commons Attribution-ShareAlike 4.0 International License'
    s.license_link = 'https://www.pharmgkb.org/page/faqs'
    s.save
    s = DataModel::Source.find_by(source_db_name: "PubChem")
    s.license = ''
    s.license_link = 'https://pubchemdocs.ncbi.nlm.nih.gov/downloads'
    s.save
    s = DataModel::Source.find_by(source_db_name: "RussLampel")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "TALC")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "TEND")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "TTD")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "TdgClinicalTrial")
    s.license = ''
    s.license_link = ''
    s.save
    s = DataModel::Source.find_by(source_db_name: "dGene")
    s.license = ''
    s.license_link = ''
    s.save
  end

  def down
    remove_column :sources, :license
    remove_column :sources, :license_link
  end
end
