require 'spec_helper'

describe 'all drugs' do
  def setup_drugs
    (1..3).map{|i| Fabricate(:drug)}
  end

  it 'should load example URL with a valid 200 status code' do
    setup_drugs
    visit '/api/v2/drugs'
    expect(page.status_code).to eq(200)
  end
end

describe 'drug details' do
  def setup_drug
    Fabricate(:drug, concept_id: 'CHEMBL1237026')
  end

  it 'should load example URL with a valid 200 status code' do
    drug = setup_drug
    visit "/api/v2/drugs/#{drug.concept_id}"
    expect(page.status_code).to eq(200)
  end
end
