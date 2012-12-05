require 'spec_helper'

describe 'druggable_gene_categories' do
  before :each do
    visit '/druggable_gene_categories'
  end

  it 'looks reasonable' do
    page.status_code.should eq(200)
  end

end
