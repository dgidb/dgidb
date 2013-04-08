require 'spec_helper'

describe 'druggable_gene_categories' do

  it 'successfully loads with an existing category' do
    category = Fabricate(:gene_claim_category)
    gene_claim = Fabricate(:gene_claim, gene_claim_categories: [category])
    Fabricate(:gene, gene_claims: [gene_claim])
    visit "/druggable_gene_categories/#{URI.encode(category.name)}"
    page.status_code.should eq(200)
  end

end
