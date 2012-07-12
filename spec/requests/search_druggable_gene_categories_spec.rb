require 'spec_helper'

describe 'search_druggable_gene_categories' do
  before :each do
    visit '/search_categories'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

  it 'searching FLT3 looks reasonable' do
    fill_in('genes', :with => 'FLT3')
    select('KINASE', :from => 'categories')
    select('TYROSINE KINASE', :from => 'categories')
    select('CELL SURFACE', :from => 'categories')
    click_button('Find Gene Categories')

    within('#by_categories') do
      page.should have_table('', rows: [['CELL SURFACE', '1', 'FLT3'], ['TYROSINE KINASE', '1', 'FLT3'], ['KINASE', '1', 'FLT3']]) 
    end

    within('#by_genes') do
      page.should have_table('', rows: [['FLT3', 'CELL SURFACE', 'FLT3'], ['FLT3', 'TYROSINE KINASE', 'FLT3'], ['FLT3', 'KINASE', 'FLT3']])
    end

    within('#search_summary_tab') do
        page.should have_content("Search Terms: 1")
        page.should have_content("Search Terms Matched Definitely: 1")
    end
  end

  it 'filters work' do
    fill_in('genes', :with => 'FLT3')
    select('KINASE', :from => 'categories')
    select('TYROSINE KINASE', :from => 'categories')
    click_button('Find Gene Categories')

    within('#by_categories') do
      page.should have_table('', rows: [['TYROSINE KINASE', '1', 'FLT3'], ['KINASE', '1', 'FLT3']])
      page.should have_table('', rows: [['CELL SURFACE', '1', 'FLT3']])
    end

    within('#by_genes') do
      page.should have_table('', rows: [['FLT3', 'TYROSINE KINASE', 'FLT3'], ['FLT3', 'KINASE', 'FLT3']])
      page.should have_table('', rows: [['FLT3', 'CELL SURFACE', 'FLT3']])
    end
  end

  it 'non-existant search terms do not break' do
    fill_in('genes', :with => 'FAKE1')
    select('KINASE', :from => 'categories')
    select('TYROSINE KINASE', :from => 'categories')
    select('CELL SURFACE', :from => 'categories')
    click_button('Find Gene Categories')

    within('#by_genes') do
      page.should have_content("Search Terms With No Matches") 
      page.should have_content("FAKE1")
    end

    within('#search_summary_tab') do
        page.should have_content("Search Terms: 1")
        page.should have_content("Search Terms With No Matches: 1")
    end
  end

  #TODO: test file upload
  #TODO: write a .tsv test

end
