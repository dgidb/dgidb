require 'spec_helper'

describe 'contact' do
  before :each do
    visit '/contact'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('Contact Us')
  end

end
