require 'spec_helper'

describe 'search_interactions' do
  it 'looks reasonable' do
    visit '/search_interactions'
    page.status_code.should eq(200)
  end

  it 'searching FLT3 looks reasonable' do
    visit '/search_interactions'
    fill_in('genes', :with => 'FLT3')
    click_button('Find Drug Interactions')
    
    within("#summary") do
      page.should have_content("Search Terms: 1")
      page.should have_content("Search Terms Matched Definitely: 1")
      page.should have_content("Number Of Interactions For Definite Matches: 2")
    end

    within("#term_summary_tab") do
      page.should have_table('', rows: [['FLT3', 'Definite', 'FLT3']]) 
    end

    within("#interaction_tab") do
      page.should have_table('', rows: [['FLT3', 'FLT3', 'SORAFENIB', 'antagonist', 'DrugBank'], ['FLT3', 'FLT3', 'SUNITINIB', 'multitarget', 'DrugBank']])
    end
  end
end
