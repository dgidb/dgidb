require 'spec_helper'
require 'pry'
require 'pry-nav'
require 'pry-remote'

describe 'druggable_gene_categories' do

  it 'successfully loads with an existing category' do
    trust_level = Fabricate(:source_trust_level, level: 'Expert curated')
    source = Fabricate(:source, source_trust_level: trust_level)
    category = Fabricate(:gene_claim_category)
    gene_claim = Fabricate(:gene_claim, source: source, gene_claim_categories: [category])
    Fabricate(:gene, gene_claims: [gene_claim])
    visit "/druggable_gene_categories/#{URI.encode(category.name)}?sources=#{URI.encode(source.source_db_name)}"
    expect(page.status_code).to eq(200)
  end

end
