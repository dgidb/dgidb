require 'spec_helper'

describe 'genes' do
  it 'should return a 404 when a gene is not found' do
    visit '/genes/testgene'
    page.status_code.should eq(404)
  end

  it 'should have case insensitive urls' do
    Fabricate(:gene, name: 'GENE1')
    visit '/genes/gene1'
    page.status_code.should eq(200)
    visit '/genes/GENE1'
    page.status_code.should eq(200)

    Fabricate(:gene, name: 'gene2')
    visit '/genes/gene2'
    page.status_code.should eq(200)
    visit '/genes/GENE2'
    page.status_code.should eq(200)
  end
end
