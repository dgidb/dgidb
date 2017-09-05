require 'spec_helper'

describe 'getting_started' do
  before :each do
    visit '/getting_started'
  end

  it 'check to see if the page exists' do
    expect(page.status_code).to eq (200)
    expect(page).to have_content('This page provides tutorials and other resources on how to use DGIdb.')
  end

end
