require 'spec_helper'

describe LookupCategories do
  describe '::find_genes_for_category_and_sources' do

    it 'should find all genes for the given category and sources' do
      source = Fabricate(:source)
      category = Fabricate(:gene_claim_category)
      gene_claims = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: source)
      end

      genes = gene_claims.map { |gc| Fabricate(:gene, gene_claims: [gc]) }
      found_genes = LookupCategories.find_genes_for_category_and_sources(category.name, [source.source_db_name])
      expect(genes.sort).to eq(found_genes.sort)
    end

    it 'should only find unique genes' do
      #multiple gene claims in the same category mapped to same gene group
      source = Fabricate(:source)
      category = Fabricate(:gene_claim_category)
      gene_claims = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: source)
      end

      gene = Fabricate(:gene, gene_claims: gene_claims)
      found_gene = LookupCategories.find_genes_for_category_and_sources(category.name, [source.source_db_name])

      expect(Array(gene)).to eq(found_gene)
    end

    it 'should only find genes in the selected category' do
      source = Fabricate(:source)
      categories = (1..2).map { Fabricate(:gene_claim_category) }

      gene_claims = (1..2).map do
        Fabricate(:gene_claim, gene_claim_categories: [categories.first], source: source)
      end

      gene_claim_in_correct_category = Fabricate(:gene_claim, gene_claim_categories: [categories.last],
                                                 source: source)

      gene_in_correct_category = Fabricate(:gene, gene_claims: [gene_claim_in_correct_category, gene_claims.first])
      gene_in_incorrect_category = Fabricate(:gene, gene_claims: gene_claims)


      found_genes = LookupCategories.find_genes_for_category_and_sources(categories.last.name, [source.source_db_name])

      expect(found_genes.include?(gene_in_correct_category)).to be true
      expect(found_genes.include?(gene_in_incorrect_category)).to be false
    end

    it 'should only find genes in the selected source' do
      source1 = Fabricate(:source)
      source2 = Fabricate(:source)
      category = Fabricate(:gene_claim_category)
      gene_claims_in_source_and_category = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: source1)
      end

      #create some gene claims in our category but not from this source
      gene_claims_not_in_source = (1..3).map do
        Fabricate(:gene_claim, gene_claim_categories: [category], source: source2)
      end

      genes_to_find = gene_claims_in_source_and_category.map { |gc| Fabricate(:gene, gene_claims: [gc]) }
      gene_claims_not_in_source.each { |gc| Fabricate(:gene, gene_claims: [gc]) }
      found_genes = LookupCategories.find_genes_for_category_and_sources(category.name, [source1.source_db_name])
      expect(genes_to_find.sort).to eq(found_genes.sort)
    end
  end

  describe '::get_category_names_with_counts_with_sources' do
    it 'should return both the category names and the correct count of gene claims in that category' do
      categories = (1..3).map { Fabricate(:gene_claim_category) }.sort_by { |c| c.name }

      source1 = Fabricate(:source)
      source2 = Fabricate(:source)

      (1..3).each { |i| Fabricate(:gene_claim, source: source1, gene_claim_categories: categories.take(i)) }

      categories_with_counts = LookupCategories.get_category_names_with_counts_in_sources(source1.source_db_name)

      categories_with_counts.each_with_index do |category, i|
        expect(categories[i].name).to eq(category.name)
        expect(categories[i].gene_claims.count).to eq(category.gene_count.to_i)
      end

      empty_results = LookupCategories.get_category_names_with_counts_in_sources(source2.source_db_name)
      expect(empty_results.size).to eq(0)
    end
  end

  describe '::gene_names_in_category' do
    def setup_category
      category = Fabricate(:gene_claim_category, name: 'TESTCATEGORY')
      gene_claim = Fabricate(:gene_claim, gene_claim_categories: [category])
      gene = Fabricate(:gene, gene_claims: [gene_claim])
      [gene, category.name]
    end

    it 'should return gene names in the given category' do
      (gene, category_name) = setup_category

      gene_names = LookupCategories.gene_names_in_category(category_name)
      expect(Array(gene.name)).to eq gene_names
    end

    it 'should be case insensitive' do
      (_, category_name) = setup_category
      expect(LookupCategories.gene_names_in_category(category_name.downcase))
        .to eq LookupCategories.gene_names_in_category(category_name.upcase)
    end

    it 'should not return gene names that are not in the category' do
      (_, category_name) = setup_category
      gene = Fabricate(:gene)
      expect(LookupCategories.gene_names_in_category(category_name)).not_to include(gene.name)
    end

  end
end
