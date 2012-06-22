require 'spec_helper'

describe 'about' do
  before :each do
    visit '/about'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('About DGIDB')
  end

end
