require 'spec_helper'

describe 'interactions' do
  def setup_interactions
    Fabricate(:source_type, type: 'potentially_druggable')
    Fabricate(:source_type, type: 'interaction')
    source = Fabricate(:source, source_db_name: 'TALC')
    g1 = Fabricate(:gene, name: 'FLT1')
    Fabricate(:interaction, gene: g1, sources: [source])
    g2 = Fabricate(:gene, name: 'MM1')
    Fabricate(:interaction, gene: g2, sources: [source])
  end

  it 'should load example URL with a valid 200 status code' do
    setup_interactions
    visit '/api/v2/interactions.json?genes=FLT1,MM1,FAKE&interaction_sources=TALC'
    expect(page.status_code).to eq(200)
  end
end

describe 'all interactions' do
  def setup_interactions
    (1..3).map do |i|
      Fabricate(:interaction)
    end
  end

  it 'should load example URL with a valid 200 status code' do
    setup_interactions
    visit '/api/v2/interactions'
    expect(page.status_code).to eq(200)
  end
end

describe 'interaction details' do
  def setup_interaction
    Fabricate(:interaction)
  end

  it 'should load example URL with a valid 200 status code' do
    interaction = setup_interaction
    visit "/api/v2/interactions/#{interaction.id}"
    expect(page.status_code).to eq(200)
  end
end
