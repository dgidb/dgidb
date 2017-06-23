require 'spec_helper'

describe Genome::Groupers::GeneGrouper do

  def create_entrez_gene_aliases
    entrez_source = Fabricate(:source, source_db_name: 'Entrez')
    gene_claims = (1..3).map { Fabricate(:gene_claim, source: entrez_source) }
    gene_claims.each do |gene_claim|
      Fabricate(:gene_claim_alias, gene_claim: gene_claim, nomenclature: 'Gene Symbol')
    end
    gene_claims
  end

  it 'should add the gene claim if the gene claim name matches the gene name (case insensitive)' do
    gene = Fabricate(:gene, name: 'Test Gene')
    gene_claims = Set.new()
    source = Fabricate(:source, source_db_name: 'Test Source')
    gene_claims << Fabricate(:gene_claim, name: 'Test Gene', source: source)
    gene_claims << Fabricate(:gene_claim, name: 'TEST GENE', source: source)

    grouper = Genome::Groupers::GeneGrouper.new
    grouper.run
    gene_claims.each { |gc| gc.reload; expect(gc.gene).not_to be_nil }
    expect(gene.gene_claims.count).to eq 2
    expect(gene.gene_aliases.count).to eq 0
  end

  it 'should add the gene claim if a gene claim alias matches the gene name (case insensitive)' do
    name = 'Test Gene'
    gene = Fabricate(:gene, name: name)
    source = Fabricate(:source, source_db_name: 'Test Source')
    gene_claim = Fabricate(:gene_claim, name: 'Nonmatching Gene Name', source: source)
    Fabricate(:gene_claim_alias, alias: name, gene_claim: gene_claim)

    grouper = Genome::Groupers::GeneGrouper.new
    grouper.run
    gene_claim.reload
    expect(gene_claim.gene).not_to be_nil
    expect(gene.gene_claims.count).to eq 1
    expect(gene.gene_aliases.count).to eq 1
  end

  it 'should add the gene claim if its name matches another grouped gene claim' do
    name = 'Test Gene'
    gene = Fabricate(:gene, name: name)
    source1 = Fabricate(:source, source_db_name: 'Source 1')
    gene_claim1 = Fabricate(:gene_claim, name: 'Nonmatching Gene Name', source: source1)
    Fabricate(:gene_claim_alias, alias: name, gene_claim: gene_claim1)
    source2 = Fabricate(:source, source_db_name: 'Source 2')
    gene_claim2 = Fabricate(:gene_claim, name: 'Nonmatching Gene Name', source: source2)
    gene_claims = [gene_claim1, gene_claim2]

    grouper = Genome::Groupers::GeneGrouper.new
    grouper.run
    gene_claims.each { |gc| gc.reload; expect(gc.gene).not_to be_nil }
    expect(gene.gene_claims.count).to eq 2
    expect(gene.gene_aliases.count).to eq 1
    expect(gene.gene_aliases.first.sources.count).to eq 2
  end

  it 'should add gene attributes' do
    name = 'Test Gene'
    gene = Fabricate(:gene, name: name)
    entrez_source = Fabricate(:source, source_db_name: 'Entrez')
    other_source = Fabricate(:source, source_db_name: 'Other')
    entrez_gene_claim = Fabricate(:gene_claim, name: name, source: entrez_source)
    other_gene_claim = Fabricate(:gene_claim, name: name, source: other_source)

    Fabricate(:gene_claim_attribute, gene_claim: entrez_gene_claim, name: 'test attribute', value: 'test value')
    Fabricate(:gene_claim_attribute, gene_claim: other_gene_claim, name: 'test attribute', value: 'test value')
    Fabricate(:gene_claim_attribute, gene_claim: other_gene_claim, name: 'other test attribute', value: 'test value')

    grouper = Genome::Groupers::GeneGrouper.new
    grouper.run

    expect(DataModel::GeneAttribute.count).to eq 2
    expect(DataModel::GeneAttribute.where(name: 'test attribute').first.sources.count).to eq 2
  end

  it 'should add gene categories' do
    name = 'Test Gene'
    gene = Fabricate(:gene, name: name)
    source = Fabricate(:source, source_db_name: 'Entrez')
    gene_claim = Fabricate(:gene_claim, name: name, source: source)
    Fabricate(:gene_claim_category, gene_claims: [gene_claim])

    grouper = Genome::Groupers::GeneGrouper.new
    grouper.run

    expect(DataModel::Gene.first.gene_categories.first).to eq DataModel::GeneClaim.first.gene_claim_categories.first
  end

end
