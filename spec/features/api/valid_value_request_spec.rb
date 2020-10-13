require 'spec_helper'

describe 'api endpoints that request valid enumerations' do
  def generate_data(type_name)
    (1..3).map { Fabricate(type_name) }
  end

  def check_data(path, compare_column, data)
    visit path
    expect(page.status_code).to eq(200)
    body = JSON.parse(page.body)
    expect(body).to be_an_instance_of(Array)
    expect(body.sort).to eq data.map(&compare_column).sort
  end

  describe 'gene_categories' do
    it 'should return a list of all current gene category names as json' do
      data = generate_data(:gene_claim_category)
      ['v1', 'v2'].each do |version|
        check_data("/api/#{version}/gene_categories.json", :name, data)
      end
    end
  end

  describe 'drug_types' do
    it 'should return a list of all drug type names in the system as json' do
      data = generate_data(:drug_claim_type)
      #This endpoint was removed in v2
      ['v1'].each do |version|
        check_data("/api/#{version}/drug_types.json", :type, data)
      end
    end
  end

  describe 'interaction_types' do
    it 'should return a list of all interaction type names in the system as json' do
      data = generate_data(:interaction_claim_type)
      ['v1', 'v2'].each do |version|
        check_data("/api/#{version}/interaction_types.json", :type, data)
      end
    end
  end

  describe 'interaction_sources' do
    it 'should return a list of all sources that provide interaction claims' do
      interaction_source_type = Fabricate(:source_type, type: 'interaction')
      source = Fabricate(:source, source_types: [interaction_source_type])
      non_interaction_source_type = Fabricate(:source_type, type: 'turkey')
      non_interaction_source = Fabricate(:source, source_types: [non_interaction_source_type])

      ['v1', 'v2'].each do |version|
        visit "/api/#{version}/interaction_sources.json"

        expect(page.status_code).to eq(200)
        body = JSON.parse(page.body)

        expect(body).to be_an_instance_of(Array)
        expect(body).to include(source.source_db_name)

        expect(body).not_to include(non_interaction_source.source_db_name)
      end
    end
  end

  describe 'source_trust_levels' do
    it 'should return a list of all source trust levels in the system as json' do
      data = generate_data(:source_trust_level)
      ['v1', 'v2'].each do |version|
        check_data("/api/#{version}/source_trust_levels.json", :level, data)
      end
    end
  end

end
