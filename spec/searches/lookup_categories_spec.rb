require 'spec_helper'
require 'pry'
require 'pry-nav'
require 'pry-remote'

describe LookupCategories do
  describe '::find_genes_for_category' do

    it 'should find all genes for the given category' do
      category = Fabricate(:gene_claim_category)
      gene_claims = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: Fabricate(:source))
      end

      genes = gene_claims.map { |gc| Fabricate(:gene, gene_claims: [gc]) }
      found_genes = LookupCategories.find_genes_for_category(category.name)
      genes.sort.should eq(found_genes.sort)
    end

    it 'should only find unique genes' do
      #multiple gene claims in the same category mapped to same gene group
      category = Fabricate(:gene_claim_category)
      gene_claims = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: Fabricate(:source))
      end

      gene = Fabricate(:gene, gene_claims: gene_claims)
      found_gene = LookupCategories.find_genes_for_category(category.name)

      Array(gene).should eq(found_gene)
    end

    it 'should only find genes in the selected category' do
      categories = (1..2).map { Fabricate(:gene_claim_category) }

      gene_claims = (1..2).map do
        Fabricate(:gene_claim, gene_claim_categories: [categories.first], source: Fabricate(:source))
      end

      gene_claim_in_correct_category = Fabricate(:gene_claim, gene_claim_categories: [categories.last],
                                                 source: Fabricate(:source))

      gene_in_correct_category = Fabricate(:gene, gene_claims: [gene_claim_in_correct_category, gene_claims.first])
      gene_in_incorrect_category = Fabricate(:gene, gene_claims: gene_claims)


      found_genes = LookupCategories.find_genes_for_category(categories.last.name)

      found_genes.include?(gene_in_correct_category).should be_true
      found_genes.include?(gene_in_incorrect_category).should be_false
    end
  end
end
