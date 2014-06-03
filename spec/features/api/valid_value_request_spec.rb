require 'spec_helper'

describe 'api endpoints that request valid enumerations' do
  def generate_and_check_data(path, type_name, compare_column)
      objs = (1..3).map { Fabricate(type_name) }

      visit path
      expect(page.status_code).to eq(200)
      body = JSON.parse(page.body)
      expect(body).to be_an_instance_of(Array)
      expect(body.sort).to eq objs.map(&compare_column).sort
  end

  describe 'gene_categories' do
    it 'should return a list of all current gene category names as json' do
      generate_and_check_data('/api/v1/gene_categories.json',
                              :gene_claim_category,
                              :name)
    end
  end

  describe 'drug_types' do
    it 'should return a list of all drug type names in the system as json' do
      generate_and_check_data('/api/v1/drug_types.json',
                              :drug_claim_type,
                              :type)
    end
  end

  describe 'interaction_types' do
    it 'should return a list of all interaction type names in the system as json' do
      generate_and_check_data('/api/v1/interaction_types.json',
                              :interaction_claim_type,
                              :type)
    end
  end

  describe 'interaction_sources' do
    it 'should return a list of all sources that provide interaction claims' do
      interaction_source_type = Fabricate(:source_type, type: 'interaction')
      source = Fabricate(:source, source_type: interaction_source_type)
      non_interaction_source_type = Fabricate(:source_type, type: 'turkey')
      non_interaction_source = Fabricate(:source, source_type: non_interaction_source_type)

      visit '/api/v1/interaction_sources.json'

      expect(page.status_code).to eq(200)
      body = JSON.parse(page.body)

      expect(body).to be_an_instance_of(Array)
      expect(body).to include(source.source_db_name)

      expect(body).not_to include(non_interaction_source.source_db_name)
    end
  end

  describe 'source_trust_levels' do
    it 'should return a list of all source trust levels in the system as json' do
      generate_and_check_data('/api/v1/source_trust_levels.json',
                              :source_trust_level,
                              :level)
    end
  end

end
