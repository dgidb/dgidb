require 'spec_helper'

describe 'search_interactions' do
  it 'looks reasonable' do
    visit '/search_interactions'
    page.status_code.should eq(200)
  end

  it 'seems to work', :js => true do 
    visit '/search_interactions'
    click_button('defaultGenes')
    click_button('Find Drug Interactions')
    binding.pry
    'hope for the best'
  end
end
