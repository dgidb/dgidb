require 'spec_helper'

describe 'gene_categories_for_sources' do
  def setup_categories_and_genes
    category = Fabricate(:gene_claim_category)
    source = Fabricate(:source)
    gene = Fabricate(:gene)
    gene_claim = Fabricate(:gene_claim, source: source, gene_claim_categories: [category], gene: gene)
    [category, source, gene_claim, gene]
  end

  it 'should return a list of json hashes that contain category names and gene counts' do
    (category, source, _, gene) = setup_categories_and_genes
    source_name = CGI::escape(source.source_db_name)
    ['v1', 'v2'].each do |version|
      visit "/api/#{version}/gene_categories_for_sources.json?sources=#{source_name}"

      expect(page.status_code).to eq(200)
      body = JSON.parse(page.body)

      expect(body).to be_an_instance_of(Array)
      expect(body.first).to be_an_instance_of(Hash)


      expect(body.first['name']).to eq(category.name)
      expect(body.first['gene_count'].to_i).to eq(1)
    end
  end

  it 'should only return categories in requested_sources' do
    (category1, source1, _) = setup_categories_and_genes
    (category2, _) = setup_categories_and_genes

    source_name = CGI::escape(source1.source_db_name)
    ['v1', 'v2'].each do |version|
      visit "/api/#{version}/gene_categories_for_sources.json?sources=#{source_name}"

      expect(page.status_code).to eq(200)
      body = JSON.parse(page.body)

      category_names = body.map { |category_hash| category_hash['name'] }
      expect(category_names).to include(category1.name)
      expect(category_names).not_to include(category2.name)
    end
  end
end
