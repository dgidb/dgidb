require 'spec_helper'

describe 'druggable_gene_categories' do
  it 'successfully loads' do
    visit '/druggable_gene_categories'
    expect(page.status_code).to eq(200)
  end

  it 'should display a list of current sources with gene category information' do
    sources = (1..3).map { Fabricate(:source) }
    categories = (1..3).map { Fabricate(:gene_claim_category) }

    categories.each_with_index do |category, i|
      gene_claim = Fabricate(:gene_claim, source: sources[i], gene_claim_categories: [category])
      Fabricate(:gene, gene_claims: [gene_claim])
    end

    visit '/druggable_gene_categories'

    sources.each do |source|
      expect(page).to have_content(source.source_db_name)
    end

  end

end
