require 'spec_helper'

describe 'drug_groups' do

  it 'SUNITINIB looks reasonable' do
    visit '/drug_groups/SUNITINIB'
    page.status_code.should eq(200)

  end
end
