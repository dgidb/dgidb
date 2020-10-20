require 'spec_helper'

describe 'search_interactions' do

  it 'loads successfully' do
    Fabricate(:source_type, type: 'interaction')
    visit '/search_interactions'
    expect(page.status_code).to eq(200)
  end

  it 'should display a list of sources that provide interactions' do
    interaction_source_type = Fabricate(:source_type, type: 'interaction')
    other_source_type = Fabricate(:source_type, type: 'gene')

    interaction_sources = (1..3).map { Fabricate(:source, source_types: [interaction_source_type]) }
    other_source = Fabricate(:source, source_types: [other_source_type])

    visit '/search_interactions'

    interaction_sources.each do |source|
      expect(page.body.include? source.source_db_name).to be true
    end

    expect(page.body.include? other_source.source_db_name).to be false
  end

  it 'should display a list of gene categories' do
    Fabricate(:source_type, type: 'interaction')
    gene_categories = (1..3).map { Fabricate(:gene_claim_category) }

    visit '/search_interactions'

    gene_categories.each do |category|
      expect(page).to have_content(category.name)
    end
  end

  it 'should display a list of interaction types' do
    Fabricate(:source_type, type: 'interaction')
    interaction_types = (1..3).map { Fabricate(:interaction_claim_type) }

    visit '/search_interactions'

    interaction_types.each do |interaction_type|
      expect(page.body.include? interaction_type.type).to be true
    end
  end

end
