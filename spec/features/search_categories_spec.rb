require 'spec_helper'

describe 'search_categories' do

  it 'loads successfully' do
    Fabricate(:source_type, type: 'potentially_druggable')
    visit '/search_categories'
    expect(page.status_code).to eq(200)
  end

  it 'should display a list of sources that are considered potentially druggable' do
    druggable_type = Fabricate(:source_type, type: 'potentially_druggable')
    non_druggable_type = Fabricate(:source_type, type: 'gene')

    druggable_sources = (1..3).map { Fabricate(:source, source_types: [druggable_type]) }
    non_druggable_source = Fabricate(:source, source_types: [non_druggable_type])

    visit '/search_categories'

    druggable_sources.each do |source|
      expect(page.body.include? source.source_db_name).to be true
    end

    expect(page.body.include? non_druggable_source.source_db_name).to be false
  end

  it 'should not display a list of source trust levels' do
    Fabricate(:source_type, type: 'potentially_druggable')
    trust_levels = (1..3).map { Fabricate(:source_trust_level) }

    visit '/search_categories'

    trust_levels.each do |level|
      expect(page).not_to have_content(level.level)
    end
  end

  it 'should display a list of gene categories' do
    Fabricate(:source_type, type: 'potentially_druggable')
    gene_categories = (1..3).map { Fabricate(:gene_claim_category) }

    visit '/search_categories'

    gene_categories.each do |category|
      expect(page).to have_content(category.name)
    end
  end

end
