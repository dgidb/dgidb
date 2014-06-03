require 'spec_helper'
require 'digest/md5'

describe Filter do
  it 'should auto register available filters' do
    expect(Filter.all_filters.count).to be > 0
  end

  it 'should only register filters that actually exist' do
    Filter.all_filters.each do |filter|
      expect(Module.const_defined?(filter.classify)).to be true
      expect(filter.classify.constantize).to be_an_instance_of(Class)
    end
  end

  it 'should return a list of registered filters when asked' do
    expect(Filter.all_filters).to be_an_instance_of(Array)
  end
end

describe FilterChain do
  before :each do
    Rails.cache.clear
    @filter_chain = FilterChain.new
  end

  it 'should combine inclusive only filters accurately' do
    @filter_chain.include_identity('test1', 1, 3)
    @filter_chain.include_identity('test1', 2, 4)
    1.upto(4) do |num|
      expect(@filter_chain.include?(num)).to be true
    end
  end

  it 'should combine exlusive only filters accurately' do
    @filter_chain.exclude_identity('test1', 1, 3)
    @filter_chain.exclude_identity('test1', 2, 4)
    1.upto(4) do |num|
      expect(@filter_chain.include?(num)).to be false
    end
  end

  it 'should combine inclusive and exclusive filters accurately' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.exclude_identity('axis1', 3, 4)
    expect(@filter_chain.include?(1)).to be true
    expect(@filter_chain.include?(3)).to be false
  end

  it 'should handle filtering across different axes simultaneously' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 2, 4)
    @filter_chain.include_identity('axis2', 3, 4)

    expect(@filter_chain.include?(3)).to be true
    expect(@filter_chain.include?(4)).to be true

    expect(@filter_chain.include?(1)).to be false
    expect(@filter_chain.include?(2)).to be false
  end

  it 'should default to all inclusive when empty' do
    expect(@filter_chain.include?('test')).to be true
  end

  it 'should cache the final result' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)
    cache_key = Digest::MD5.hexdigest('identity.1-3.identity.3-4')
    expect(Rails.cache.exist?(cache_key)).to be true
  end

  it 'should cache the intermediate results' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)

    cache_key = Digest::MD5.hexdigest('identity.1-3')
    expect(Rails.cache.exist?(cache_key)).to be true
    cache_key = Digest::MD5.hexdigest('identity.3-4')
    expect(Rails.cache.exist?(cache_key)).to be true
  end

  it 'should order cache keys consistently regardless of filter order' do
    @filter_chain.include_identity('axis1', 3, 4)
    @filter_chain.include_identity('axis1', 1, 3)

    @filter_chain.include?(1)
    cache_key = Digest::MD5.hexdigest('identity.1-3.identity.3-4')
    expect(Rails.cache.exist?(cache_key)).to be true
    cache_key = Digest::MD5.hexdigest('identity.3-4.identity.1-3')
    expect(Rails.cache.exist?(cache_key)).to be false

    @filter_chain = FilterChain.new
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)
    cache_key = Digest::MD5.hexdigest('identity.1-3.identity.3-4')
    expect(Rails.cache.exist?(cache_key)).to be true
    cache_key = Digest::MD5.hexdigest('identity.3-4.identity.1-3')
    expect(Rails.cache.exist?(cache_key)).to be false
  end

  it 'should recompute as needed when new filters are added' do
    @filter_chain.include_identity('axis1', 1, 2)
    expect(@filter_chain.include?(1)).to be true
    expect(@filter_chain.include?(3)).to be false
    @filter_chain.include_identity('axis1', 3)
    expect(@filter_chain.include?(3)).to be true
  end

  it 'should define include and exclude methods for registered filters' do
    Filter.all_filters.each do |filter|
      expect(@filter_chain.respond_to?("include_#{filter}")).to be true
      expect(@filter_chain.respond_to?("exclude_#{filter}")).to be true
    end
  end

end
