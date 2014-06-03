require 'spec_helper'

describe 'faq' do
  before :each do
    visit '/faq'
  end

  it 'check to see if the page exists' do
    expect(page.status_code).to eq (200)
    expect(page).to have_content('frequently asked questions')
  end

end
