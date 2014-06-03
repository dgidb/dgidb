require 'spec_helper'

describe LookupRelatedDrugs do
  it 'should find drugs that have matching names' do
    drug = Fabricate(:drug, name: 'Turkey Sandwich')
    results = LookupRelatedDrugs.find('Turkey')
    expect(results.size).to eq(1)
    expect(results.first.instance_variable_get("@drug")).to eq(drug)
  end

  it 'should wrap the result(s) in a RelatedDrugPresenter object' do
    Fabricate(:drug, name: 'Turkey Sandwich')
    results = LookupRelatedDrugs.find('Turkey')
    expect(results.first).to be_a(RelatedDrugPresenter)
  end

  it 'should not return the same drug that was searched' do
    Fabricate(:drug, name: 'turkey')
    Fabricate(:drug, name: 'turkey sandwich')

    results = LookupRelatedDrugs.find('turkey')
    expect(results.size).to eq(1)
    expect(results.first.instance_variable_get("@drug").name).to eq('turkey sandwich')
  end

  it 'should find drugs that have drug claims with matching names' do
    Fabricate(:drug, name: 'turkey')
    drug = Fabricate(:drug, name: 'sandwich meats')
    Fabricate(:drug_claim, drugs: [drug], name: 'turkey')

    results = LookupRelatedDrugs.find('turkey')
    expect(results.size).to eq(1)
    expect(results.first.instance_variable_get("@drug")).to eq(drug)
  end

  it 'should find drugs that have drug claim aliases with matching names' do
    Fabricate(:drug, name: 'turkey')
    drug = Fabricate(:drug, name: 'sandwich meats')
    drug_claim = Fabricate(:drug_claim, drugs: [drug], name: 'lunchable')
    Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'turkey sandwich')
    results = LookupRelatedDrugs.find('turkey')
    expect(results.size).to eq(1)
    expect(results.first.instance_variable_get("@drug")).to eq(drug)
  end

  it 'should only return unique drugs' do
    drug = Fabricate(:drug, name: 'sandwich')
    Fabricate(:drug_claim, name: 'turkey', drugs: [drug])
    Fabricate(:drug_claim, name: 'turkey sandwich', drugs: [drug])
    results = LookupRelatedDrugs.find('turkey')
    expect(results.size).to eq(1)
  end
end
