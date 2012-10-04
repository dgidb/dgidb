require 'spec_helper'

describe 'getting_started' do
  before :each do
    visit '/getting_started'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('familiarize yourself with DGIDB')
  end

end
