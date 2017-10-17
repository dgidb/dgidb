require 'spec_helper'

describe 'all genes' do
  def setup_genes
    (1..3).map{|i| Fabricate(:gene)}
  end

  it 'should load example URL with a valid 200 status code' do
    setup_genes
    visit '/api/v2/genes'
    expect(page.status_code).to eq(200)
  end
end

describe 'gene details' do
  def setup_gene
    Fabricate(:gene, entrez_id: 346)
  end
  it 'should load example URL with a valid 200 status code' do
    gene = setup_gene
    visit "/api/v2/genes/#{gene.entrez_id}"
    expect(page.status_code).to eq(200)
  end
end
