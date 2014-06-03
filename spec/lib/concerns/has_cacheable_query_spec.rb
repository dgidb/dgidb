require 'spec_helper'

class MockOperation
  def self.mock_calculation(arg1 = 1, arg2 = 2)
    arg1 + arg2
  end

  def self.mock_calculation2(arg1 = 2, arg2 = 3)
    arg1 + arg2
  end
end

class CachedMockOperation
  include Genome::Extensions::HasCacheableQuery
  cache_query :mock_calculation, 'cached_mock'
  cache_query :mock_calculation2, 'cached_mock2'
  def self.mock_calculation(arg1 = 1, arg2 = 2)
    arg1 + arg2
  end

  def self.mock_calculation2(arg1 = 2, arg2 = 3)
    arg1 + arg2
  end
end

class UnorderedMockOperation
  include Genome::Extensions::HasCacheableQuery
  def self.mock_calculation(arg1 = 1, arg2 = 2)
    arg1 + arg2
  end
  cache_query :mock_calculation, 'unordered_cached_mock'
end

describe 'HasCacheableQuery concern' do

  before :each do
    Rails.cache.clear
    @cached = CachedMockOperation
    @uncached = MockOperation
    @unordered = UnorderedMockOperation
  end

  it 'should define a method called cache_query on the class it is mixed in to' do
    expect(CachedMockOperation.respond_to?(:cache_query)).to be true
    expect(MockOperation.respond_to?(:cache_query)).to be false
  end

  it 'should produce the same result as a method that is not cached' do
    expect(@cached.mock_calculation).to eq(@uncached.mock_calculation)
    expect(@cached.mock_calculation).to eq(@uncached.mock_calculation)
  end

  it 'should cache the result of the query' do
    @cached.mock_calculation
    expect(Rails.cache.exist?("cached_mock.#{[].to_s}")).to be true
  end

  it 'should cache results differently given different argument lists' do
    expect(@cached.mock_calculation).to eq 3
    expect(Rails.cache.exist?("cached_mock.#{[].to_s}")).to be true
    expect(@cached.mock_calculation(4,5)).to eq 9
    expect(Rails.cache.exist?("cached_mock.#{[4,5].to_s}")).to be true
  end

  it 'should cache different methods with different keys when given them' do
    expect(@cached.mock_calculation).to eq 3
    expect(Rails.cache.exist?("cached_mock.#{[].to_s}")).to be true
    expect(@cached.mock_calculation2).to eq 5
    expect(Rails.cache.exist?("cached_mock2.#{[].to_s}")).to be true
  end

  it 'should work regardless of the order of method definition vs the cache_query call' do
    @unordered.mock_calculation
    expect(Rails.cache.exist?("unordered_cached_mock.#{[].to_s}")).to be true
  end
end
