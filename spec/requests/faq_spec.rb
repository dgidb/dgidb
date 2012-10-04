require 'spec_helper'

describe 'faq' do
  before :each do
    visit '/faq'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('frequently asked questions')
  end

end
