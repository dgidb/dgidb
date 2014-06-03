require 'spec_helper'

describe LookupGenes do
  describe '::find' do

    DummyWrapper = Struct.new(:search_terms, :matched_genes)

    def search_string
      'TURKEY'
    end

    def check_matched_gene_against_results(matched_gene)
      results = LookupGenes.find([search_string], :for_search, DummyWrapper)
      expect(results.size).to eq(1)
      expect(results.first.search_terms).to eq Array(search_string)
      expect(results.first.matched_genes.size).to eq(1)
      expect(results.first.matched_genes).to eq Array(matched_gene)
    end

    it 'should give gene name matches precedence' do
      gene_claim = Fabricate(:gene_claim, name: search_string)
      gene_claim_with_alias = Fabricate(:gene_claim)
      Fabricate(:gene_claim_alias, gene_claim: gene_claim_with_alias, alias: search_string)
      Fabricate(:gene, gene_claims: [gene_claim_with_alias])
      Fabricate(:gene, gene_claims: [gene_claim])
      matched_gene = Fabricate(:gene, name: search_string)
      check_matched_gene_against_results(matched_gene)
    end

    it 'should check gene claim aliases after genes' do
      gene_claim = Fabricate(:gene_claim, name: search_string)
      gene_claim_with_alias = Fabricate(:gene_claim)
      Fabricate(:gene_claim_alias, gene_claim: gene_claim_with_alias, alias: search_string)
      matched_gene = Fabricate(:gene, gene_claims: [gene_claim_with_alias])
      Fabricate(:gene, gene_claims: [gene_claim])
      check_matched_gene_against_results(matched_gene)
    end

    it 'should check gene claim names last' do
      gene_claim = Fabricate(:gene_claim, name: search_string)
      matched_gene = Fabricate(:gene, gene_claims: [gene_claim])
      check_matched_gene_against_results(matched_gene)
    end

    it 'should de-duplicate search terms that map to the same values' do
      gene_claim = Fabricate(:gene_claim)
      gene = Fabricate(:gene, gene_claims: [gene_claim])
      gene_claim_aliases = (1..2).map { Fabricate(:gene_claim_alias, gene_claim: gene_claim) }
      results = LookupGenes.find(gene_claim_aliases.map(&:alias), :for_search, DummyWrapper)
      expect(results.size).to eq(1)
      expect(results.first.search_terms).to eq(gene_claim_aliases.map(&:alias))
      expect(results.first.matched_genes).to eq(Array(gene))
    end

    it 'should wrap the results in the given class' do
      genes = (1..3).map { Fabricate(:gene) }
      results = LookupGenes.find(genes.map(&:name), :for_search, DummyWrapper)
      results.each do |result|
        expect(result.is_a?(DummyWrapper)).to be true
      end
    end

    it 'should not allow an empty list of search terms' do
      expect { LookupGenes.find([], :for_search, DummyWrapper) }.to raise_error
    end

    it 'should handle no search terms being matched gracefully' do
      (1..3).each { Fabricate(:gene) }
      results = LookupGenes.find(['fake name'], :for_search, DummyWrapper)
      expect(results.size).to eq(1)
      expect(results.first.matched_genes.empty?).to be true
    end

    it 'should send the correct eager loading scope to the underlying model' do
      genes = (1..3).map { Fabricate(:gene) }
      [DataModel::Gene, DataModel::GeneClaimAlias, DataModel::GeneClaim].each do |klass|
        expect(klass).to receive(:for_search).once.and_return(klass)
      end
      LookupGenes.find(genes.map(&:name), :for_search, DummyWrapper)
    end
  end
end
