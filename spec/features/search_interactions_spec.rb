require 'spec_helper'

describe 'search_interactions' do

  before :each do
    visit '/search_interactions'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

end
