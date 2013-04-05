require 'spec_helper'

describe 'druggable_gene_categories' do
  it 'successfully loads' do
    visit '/druggable_gene_categories'
    page.status_code.should eq(200)
  end

  it 'should display a list of current gene claim categories' do
    categories = (1..3).map { Fabricate(:gene_claim_category) }

    categories.each do |category|
      Fabricate(:gene_claim, gene_claim_categories: [category])
    end

    visit '/druggable_gene_categories'

    categories.each do |category|
      page.should have_content(category.name)
    end

  end

end
