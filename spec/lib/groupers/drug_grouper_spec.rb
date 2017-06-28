require 'spec_helper'

describe Genome::Groupers::DrugGrouper do
  def create_chembl_drug_aliases
    nil
  end
  def create_chembl_drug_attributes
    nil
  end

  it 'should add the drug claim if the drug claim name matches the drug name (case insensitive)' do
    drug = Fabricate(:drug, name: 'Test Drug')
    drug_claims = Set.new
    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claims << Fabricate(:drug_claim, name: 'Test Drug', source: source, primary_name: 'Test Drug')
    drug_claims << Fabricate(:drug_claim, name: 'TEST DRUG', source: source, primary_name: 'TEST DRUG')

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claims.each { |dc| dc.reload; expect(dc.drug).not_to be_nil }
    expect(drug.drug_claims.count).to eq 2
    expect(drug.drug_aliases.count).to eq 0
    expect(drug.drug_attributes.count).to eq 0
  end

  it 'should add the drug claim if a drug claim alias matches the drug name (case insensitive)' do
    name = 'Test Drug'
    drug = Fabricate(:drug, name: name)
    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Nonmatching Drug Name', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, alias: name, drug_claim: drug_claim)
    Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    expect(drug_claim.drug).not_to be_nil
    expect(drug.drug_claims.count).to eq 1
    expect(drug.drug_aliases.count).to eq 1
    expect(drug.drug_attributes.count).to eq 1
  end

  it 'should add the drug claim if its name matches another grouped drug claim' do
    drug_name = 'Test Drug'
    drug = Fabricate(:drug, name: drug_name)

    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Test Drug Trade Name', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'Test Drug')
    Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

    another_source = Fabricate(:source, source_db_name: 'Test Clinical Source')
    another_drug_claim = Fabricate(:drug_claim, name: 'Test Drug Trade Name', source: another_source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: another_drug_claim, alias: 'Bogus Drug Name')
    Fabricate(:drug_claim_attribute, drug_claim: another_drug_claim, name: 'kerbanol groups', value: 3)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug.reload
    expect(drug.drug_claims.count).to eq 2
    expect(drug.drug_aliases.count).to eq 2
    expect(drug.drug_attributes.count).to eq 2
  end

  it 'should add the drug claim if its alias matches another grouped drug claim alias' do
    drug_name = 'Test Drug'
    drug = Fabricate(:drug, name: drug_name)
    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Test Drug', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'Test Drug Trade Name')
    Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

    another_source = Fabricate(:source, source_db_name: 'Test Clinical Source')
    another_drug_claim = Fabricate(:drug_claim, name: 'Bogus Drug Name', source: another_source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: another_drug_claim, alias: 'Test Drug Trade Name')
    Fabricate(:drug_claim_attribute, drug_claim: another_drug_claim, name: 'kerbanol groups', value: 3)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug.reload
    expect(drug.drug_claims.count).to eq 2
    expect(drug.drug_aliases.count).to eq 2
    expect(drug.drug_attributes.count).to eq 2
  end

  it 'should not add the drug claim if its alias matches multiple drug aliases' do
    drug = Fabricate(:drug, name: 'Test Drug')
    drug_alias = Fabricate(:drug_alias, drug: drug)

    another_drug = Fabricate(:drug, name: 'Another Test Drug')
    another_drug_alias = Fabricate(:drug_alias, drug: another_drug)

    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Drug Trade Name', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_drug_alias.alias)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: drug_alias.alias)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    expect(drug_claim.drug).to be_nil
    expect(grouper.indirect_multimatch.count).to eq 1
  end

  it 'should not add the drug claim if it matches multiple drug names' do
    drug = Fabricate(:drug)

    another_drug = Fabricate(:drug)

    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Drug Trade Name', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: drug.name)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_drug.name)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    expect(drug_claim.drug).to be_nil
    expect(grouper.direct_multimatch.count).to eq 1
    expect(grouper.indirect_multimatch.count).to eq 0
  end

  it 'should not add the drug claim if it matches multiple molecule names' do
    molecule = Fabricate(:chembl_molecule, pref_name: 'NOTREAL')
    another_molecule = Fabricate(:chembl_molecule, pref_name: 'LAERTON')

    drug_claim = Fabricate(:drug_claim)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: molecule.pref_name)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_molecule.pref_name)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    expect(drug_claim.drug).to be_nil
    expect(grouper.molecule_multimatch.count).to eq 1
  end

  it 'should not add the drug claim if its name or aliases match multiple molecule synonyms, unless from the same molecule' do
    molecule_synonym = Fabricate(:chembl_molecule_synonym)
    molecule_synonym_2 = Fabricate(:chembl_molecule_synonym, chembl_molecule: molecule_synonym.chembl_molecule)

    another_molecule_synonym = Fabricate(:chembl_molecule_synonym)

    drug_claim = Fabricate(:drug_claim, primary_name: molecule_synonym.synonym)
    drug_claim_alias = Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_molecule_synonym.synonym)

    another_drug_claim = Fabricate(:drug_claim, primary_name: molecule_synonym.synonym)
    another_drug_claim_alias = Fabricate(:drug_claim_alias, drug_claim: another_drug_claim, alias: molecule_synonym_2.synonym)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run

    drug_claim.reload
    another_drug_claim.reload
    expect(drug_claim.drug).to be_nil
    expect(another_drug_claim.drug).not_to be_nil
    expect(grouper.molecule_multimatch.count).to eq 1

  end


  it 'should add a drug if the drug claim matches a molecule, and add the drug claim to the drug' do
    drug_name = 'Test Drug'
    molecule = Fabricate(:chembl_molecule, pref_name: drug_name)
    Fabricate(:chembl_molecule_synonym, chembl_molecule: molecule, synonym: 'Generic Trade Name')

    source = Fabricate(:source, source_db_name: 'Test Source')
    drug_claim = Fabricate(:drug_claim, name: 'Test Drug', source: source, primary_name: nil)
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'Test Drug Trade Name')
    Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    drug = drug_claim.drug
    expect(drug).not_to be_nil
    expect(drug.name).to eq drug_name
    expect(drug.chembl_molecule).to eq molecule

  end

  it 'should properly update drug flags after grouping' do
    approved_molecule = Fabricate(:chembl_molecule, max_phase: 4, withdrawn_flag: false)
    withdrawn_molecule = Fabricate(:chembl_molecule, max_phase: 4, withdrawn_flag: true)
    unapproved_molecule = Fabricate(:chembl_molecule, max_phase: 2, withdrawn_flag: false)

    approved_drug = Fabricate(:drug, chembl_molecule: approved_molecule)
    withdrawn_drug = Fabricate(:drug, chembl_molecule: withdrawn_molecule)
    unapproved_drug = Fabricate(:drug, chembl_molecule: unapproved_molecule)

    expect(approved_drug.fda_approved).to be_truthy
    expect(withdrawn_drug.fda_approved).to be_falsey
    expect(unapproved_drug.fda_approved).to be_falsey

    immunotherapy_molecule = Fabricate(:chembl_molecule, molecule_type: 'Antibody')
    small_molecule = Fabricate(:chembl_molecule, molecule_type: 'Small molecule')

    immunotherapy_drug = Fabricate(:drug, chembl_molecule: immunotherapy_molecule)
    non_immunotherapy_drug = Fabricate(:drug, chembl_molecule: small_molecule)

    expect(immunotherapy_drug.immunotherapy).to be_truthy
    expect(non_immunotherapy_drug.immunotherapy).to be_falsey

    anti_neoplastic_drugs =
      %w[TALC ClearityFoundationClinicalTrial ClearityFoundationBiomarkers CancerCommons
                                      MyCancerGenome CIViC MyCancerGenomeClinicalTrial].map do |source_db_name|
        source = Fabricate(:source, source_db_name: source_db_name)
        drug_claim = Fabricate(:drug_claim, source: source)
        drug = Fabricate(:drug, name: drug_claim.primary_name)
    end

    source = Fabricate(:source, source_db_name: 'ChEMBL')
    chembl_drug_claim = Fabricate(:drug_claim, source: source)
    chembl_drug = Fabricate(:drug, name: chembl_drug_claim.primary_name)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    anti_neoplastic_drugs.each do |drug|
      drug.reload
      expect(drug.drug_claims.count).to eq 1
      drug.send(:update_anti_neoplastic_add, drug.drug_claims.first) # Why does this need to be done for rspec?
      expect(drug.anti_neoplastic).to be_truthy,
        "drug with drug_claim source of #{drug.drug_claims.first.source.source_db_name} has anti_neoplastic flag of #{drug.anti_neoplastic}."
    end
    chembl_drug.send(:update_anti_neoplastic_add, chembl_drug.drug_claims.first)
    expect(chembl_drug.anti_neoplastic).to be_falsey
  end
end