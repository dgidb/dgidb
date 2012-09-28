require 'spec_helper'

describe 'sources' do
  before :each do
    visit '/sources'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('drug gene interaction database')
  end

end
