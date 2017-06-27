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

  it 'should not add the drug claim if its alias matches multiple drugs' do
    nil
  end

  it 'should add a drug if the drug claim matches a molecule, and add the drug claim to the drug' do
    nil
  end

  it 'should add a drug if the drug claim matches a molecule alias, and add the drug claim to the drug' do
    nil
  end

  it 'should properly update drug flags after grouping' do
    nil
  end
end