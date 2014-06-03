require 'spec_helper'

describe Search do
  before :each do
    @entities = {
        DataModel::Gene => :name,
        DataModel::Drug => :name,
        DataModel::GeneClaimAlias => :alias,
        DataModel::DrugClaimAlias => :alias,
        DataModel::GeneClaim => :name,
        DataModel::DrugClaim => :name
    }
  end

  it 'should use the textacular .advanced_search to leverage postgres full text search' do
    @entities.keys.each do |model|
      expect(model).to receive(:advanced_search).and_return([])
    end
    Search.search('turkey')
  end

  it 'should throw an exception if given a blank or nil input' do
    expect { Search.search(nil) }.to raise_error
    expect { Search.search('') }.to raise_error
    expect { Search.search('  ') }.to raise_error
  end

  it 'should wrap results in SearchResultPresenter objects' do
    Fabricate(:drug, name: 'turkey')
    results = Search.search('turkey')

    expect(results.size).to eq(1)
    expect(results.first).to be_a(SearchResultPresenter)
  end

  it 'should search the correct field for each entity type' do
    search_term = 'test'
    @entities.each do |model, field|
      expect(model).to receive(:advanced_search)
        .with({field => "#{search_term}:*"})
        .and_return([])
    end
    Search.search(search_term)
  end
end
