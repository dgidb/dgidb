require 'spec_helper'

describe 'contact' do
  before :each do
    visit '/contact'
  end

  it 'check to see if the page exists' do
    expect(page.status_code).to eq (200)
    expect(page).to have_content('contact us')
  end

end
