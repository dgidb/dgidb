require 'spec_helper'

describe 'news' do
  before :each do
    visit '/news'
  end

  it 'check to see if the page exists' do
    page.status_code.should eq (200)
    page.should have_content('latest news regarding DGIdb')
  end

end
