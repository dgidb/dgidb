require 'spec_helper'

describe 'drugs' do

  it 'SUNITINIB looks reasonable' do
    Fabricate(:drug, name: 'SUNITINIB')
    visit '/drugs/SUNITINIB'
    expect(page.status_code).to eq(200)

  end
end
