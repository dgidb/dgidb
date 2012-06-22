require 'spec_helper'

describe 'druggable_gene_categories' do
  before :each do
    visit '/druggable_gene_categories'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

  it 'Cell Surface looks reasonable' do
    page.should have_content('CELL SURFACE (1)')
    page.should have_content('KINASE (1)')
    page.should have_content('TYROSINE KINASE (1)')
  end
end
