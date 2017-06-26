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
    drug_claims << Fabricate(:drug_claim, name: 'Test Drug', source: source)
    drug_claims << Fabricate(:drug_claim, name: 'TEST DRUG', source: source)

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
    drug_claim = Fabricate(:drug_claim, name: 'Nonmatching Drug Name', source: source)
    Fabricate(:drug_claim_alias, alias: name, drug_claim: drug_claim)
    Fabricate(:drug_claim_attribute, drug_claim: drug_claim)

    grouper = Genome::Groupers::DrugGrouper.new
    grouper.run
    drug_claim.reload
    expect(drug_claim.drug).not_to be_nil
    expect(drug.drug_claims.count).to eq 1
    expect(drug.drug_aliases.count).to eq 1
    expect(drug.drug_attributes.count).to eq 1
  end

  it 'should add the drug claim if its name matches another grouped drug claim' do
    nil
  end

  it 'should add the drug claim if its alias matches another grouped drug claim alias' do
    nil
  end

  it 'should not add the drug claim if its alias matches multiple drugs' do
    nil
  end

  it 'should add a drug if the drug claim matches a molecule, and add the drug claim to the drug' do
    nil
  end

  it 'should add a drug if the drug claim matches a molecule alias, and add the drug claim to the drug' do
    nil
  end
end