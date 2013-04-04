require 'spec_helper'

describe 'drugs' do

  it 'SUNITINIB looks reasonable' do
    Fabricate(:drug, name: 'SUNITINIB')
    visit '/drugs/SUNITINIB'
    page.status_code.should eq(200)

  end
end
