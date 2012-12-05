require 'spec_helper'

describe 'search_druggable_gene_categories' do
  before :each do
    visit '/search_categories'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

end
