require 'spec_helper'

describe 'search_interactions' do

  before :each do
    visit '/search_interactions'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

  it 'searching FLT3 looks reasonable' do
    fill_in('genes', :with => 'FLT3')
    select('DrugBank', :from => 'sources')
    select('TTD', :from => 'sources')
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
      page.should have_table('', rows: [['FLT3', 'FLT3', 'SUNITINIB', 'multitarget', 'DrugBank'], ['FLT3', 'FLT3', 'SORAFENIB', 'antagonist', 'DrugBank']])
    end
  end

  it 'searching with "inhibitors only" filter looks reasonable' do
    fill_in('genes', :with => "FLT1\nFLT2")
    select('DrugBank', :from => 'sources')
    select('TTD', :from => 'sources')
    select('Inhibitors only', :from => 'filter')
    click_button('Find Drug Interactions')

    within("#summary") do
      page.should have_content("Search Terms: 2")
      page.should have_content("Search Terms Matched Definitely: 2")
      page.should have_content("Number Of Interactions For Definite Matches: 3")
    end

    within("#term_summary_tab") do
      page.should have_table('', rows: [['FLT1', 'Definite', 'FLT1'], ['FLT2', 'Definite', 'FGFR1']]) 
    end

    within("#interaction_tab") do
      page.should have_table('', rows: [["FLT1","FLT1","RANIBIZUMAB","inhibitor","TTD"],["FLT1","FLT1","SORAFENIB","inhibitor","TTD"]]) 
      page.should have_table('', rows: [["FLT2","FGFR1","PALIFERMIN","n/a","DrugBank"]])
    end
  end

  it 'searching with TTD only looks reasonable' do
    fill_in('genes', :with => "FLT3\nFLT2\nFLT1\nSTK1")
    select('TTD', :from => 'sources')
    click_button('Find Drug Interactions')

    within("#summary") do
      page.should have_content("Search Terms: 4")
      page.should have_content("Search Terms Matched Definitely: 3")
      page.should have_content("Search Terms Matched Ambiguously: 1")
      page.should have_content("Number Of Interactions For Definite Matches: 2")
    end

    within("#term_summary_tab") do
      page.should have_table('', rows: [['FLT3', 'Definite', 'FLT3'], ['FLT2', 'Definite', 'FGFR1'], ['FLT1', 'Definite', 'FLT1']]) 
    end

    within("#interaction_tab") do
      page.should have_table('', rows: [["FLT1","FLT1","RANIBIZUMAB","inhibitor","TTD"], ["FLT1","FLT1","SORAFENIB","inhibitor","TTD"]])
    end
  end

  #TODO: test file upload
  #TODO: write a .tsv test

end
