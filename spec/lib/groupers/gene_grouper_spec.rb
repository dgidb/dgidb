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

  it 'should create a gene entity for each Entrez gene symbol' do
    create_entrez_gene_aliases

    Genome::Groupers::GeneGrouper.run

    expect(DataModel::Gene.all.count).to eq DataModel::GeneClaimAlias.all.count
    gene_names = DataModel::Gene.pluck(:name).sort
    gene_claim_aliases = DataModel::GeneClaimAlias.pluck(:alias).sort
    expect(gene_names).to eq gene_claim_aliases
  end

  it 'should not create gene entities for non-Entrez gene symbols' do
    create_entrez_gene_aliases
    non_entrez_source = Fabricate(:source, source_db_name: 'NotEntrez')
    non_entrez_gene_claim = Fabricate(:gene_claim, source: non_entrez_source)
    gene_claim_alias = Fabricate(:gene_claim_alias, gene_claim: non_entrez_gene_claim)

    Genome::Groupers::GeneGrouper.run

    expect(DataModel::Gene.all.count).to eq DataModel::GeneClaimAlias.all.count - 1
    expect(DataModel::Gene.where(name: gene_claim_alias.alias).count).to eq 0
  end

  it 'should add the gene claims used to create the gene entities to their genes' do
    gene_claims = create_entrez_gene_aliases
    gene_claims.each { |gc| expect(gc.genes.count).to eq 0 }
    Genome::Groupers::GeneGrouper.run
    gene_claims.each { |gc| expect(gc.genes.count).to eq 1 }
  end

  it 'should add gene claims to the gene if there was only one direct match' do
    (grouped_gene_claim,_) = create_entrez_gene_aliases
    gene_claim_to_group = Fabricate(:gene_claim,
                                    name: grouped_gene_claim.gene_claim_aliases.first.alias)
    Genome::Groupers::GeneGrouper.run

    expect(grouped_gene_claim.genes).to eq gene_claim_to_group.genes
  end

  it 'should add gene claims if there were no direct matches and one indirect match' do
    grouped_gene_claims = create_entrez_gene_aliases
    test_name = 'test gene name'
    Fabricate(:gene_claim_alias, alias: test_name, gene_claim: grouped_gene_claims.first)

    ungrouped_gene_claim = Fabricate(:gene_claim)
    Fabricate(:gene_claim_alias, alias: test_name, gene_claim: ungrouped_gene_claim)

    Genome::Groupers::GeneGrouper.run

    entrez_gene = grouped_gene_claims.first.genes.first
    grouped_gene = ungrouped_gene_claim.genes.first

    expect(entrez_gene).to eq grouped_gene
  end

  it 'should add the gene claim to the gene if there is 1 direct match even if there are indirect matches' do
    grouped_gene_claims = create_entrez_gene_aliases
    test_name = 'test gene name'
    Fabricate(:gene_claim_alias, alias: test_name,
              gene_claim: grouped_gene_claims.first)

    ungrouped_gene_claim = Fabricate(:gene_claim,
              name: grouped_gene_claims.last.gene_claim_aliases.first.alias)

    Fabricate(:gene_claim_alias,
              alias: test_name, gene_claim: ungrouped_gene_claim)

    Genome::Groupers::GeneGrouper.run
    expect(ungrouped_gene_claim.genes).not_to be_empty
  end

  describe 'it should not add gene claims if there was any ambiguity' do
    it 'has > 1 direct match' do
      (grouped_gene_claim, other_grouped_gene_claim) = create_entrez_gene_aliases
      gene_claim_to_group = Fabricate(:gene_claim,
                                      name: grouped_gene_claim.gene_claim_aliases.first.alias)
      Fabricate(:gene_claim_alias, gene_claim: gene_claim_to_group,
                alias: other_grouped_gene_claim.gene_claim_aliases.first.alias)

      Genome::Groupers::GeneGrouper.run

      expect(gene_claim_to_group.genes).to be_empty
    end

    it 'has > 1 indirect' do
      grouped_gene_claims = create_entrez_gene_aliases
      test_name = 'test gene name'
      Fabricate(:gene_claim_alias, alias: test_name, gene_claim: grouped_gene_claims.first)
      test_name2 = 'test gene name 2'
      Fabricate(:gene_claim_alias, alias: test_name2, gene_claim: grouped_gene_claims.last)

      ungrouped_gene_claim = Fabricate(:gene_claim)
      Fabricate(:gene_claim_alias, alias: test_name, gene_claim: ungrouped_gene_claim)
      Fabricate(:gene_claim_alias, alias: test_name2, gene_claim: ungrouped_gene_claim)

      Genome::Groupers::GeneGrouper.run

      expect(ungrouped_gene_claim.genes).to be_empty
    end

  end

end
