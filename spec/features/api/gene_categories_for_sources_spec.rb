require 'spec_helper'

describe 'gene_categories_for_sources' do
  def setup_categories_and_genes
    category = Fabricate(:gene_claim_category)
    source = Fabricate(:source)
    gene_claim = Fabricate(:gene_claim, source: source, gene_claim_categories: [category])
    genes = (1..3).map { Fabricate(:gene, gene_claims: [gene_claim]) }
    [category, source, gene_claim, genes]
  end

  it 'should return a list of json hashes that contain category names and gene counts' do
    (category, source, _, genes) = setup_categories_and_genes
    source_name = CGI::escape(source.source_db_name)
    visit "/api/v1/gene_categories_for_sources.json?sources=#{source_name}"

    page.status_code.should eq(200)
    body = JSON.parse(page.body)

    body.should be_an_instance_of(Array)
    body.first.should be_an_instance_of(Hash)


    body.first['name'].should eq(category.name)
    body.first['gene_count'].to_i.should eq(genes.count)
  end

  it 'should only return categories in requested_sources' do
    (category1, source1, _) = setup_categories_and_genes
    (category2, _) = setup_categories_and_genes

    source_name = CGI::escape(source1.source_db_name)
    visit "/api/v1/gene_categories_for_sources.json?sources=#{source_name}"

    page.status_code.should eq(200)
    body = JSON.parse(page.body)

    category_names = body.map { |category_hash| category_hash['name'] }
    category_names.should include(category1.name)
    category_names.should_not include(category2.name)
  end
end
