require 'spec_helper'

describe 'search_druggable_gene_categories' do
  before :each do
    Rails.cache.clear
  end

  after :each do
    DataModel::SourceType.delete_all
  end

  it 'looks reasonable' do
    Fabricate(:source_type, type: 'potentially_druggable')
    visit '/search_categories'
    page.status_code.should eq(200)
  end

end
