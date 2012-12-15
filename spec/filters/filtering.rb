require 'spec_helper'

describe Filter do
  it 'should auto register available filters' do
    Filter.all_filters.count.should be > 0
  end

  it 'should only register filters that actually exist' do
    Filter.all_filters.each do |filter|
      Module.const_defined?(filter.classify).should be_true
      filter.classify.constantize.should be_an_instance_of(Class)
    end
  end

  it 'should return a list of registered filters when asked' do
    Filter.all_filters.should be_an_instance_of(Array)
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
      @filter_chain.include?(num).should be_true
    end
  end

  it 'should combine exlusive only filters accurately' do
    @filter_chain.exclude_identity('test1', 1, 3)
    @filter_chain.exclude_identity('test1', 2, 4)
    1.upto(4) do |num|
      @filter_chain.include?(num).should be_false
    end
  end

  it 'should combine inclusive and exclusive filters accurately' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.exclude_identity('axis1', 3, 4)
    @filter_chain.include?(1).should be_true
    @filter_chain.include?(3).should be_false
  end

  it 'should handle filtering across different axes simultaneously' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 2, 4)
    @filter_chain.include_identity('axis2', 3, 4)

    @filter_chain.include?(3).should be_true
    @filter_chain.include?(4).should be_true

    @filter_chain.include?(1).should be_false
    @filter_chain.include?(2).should be_false
  end

  it 'should not break when given no filters' do
    @filter_chain.include?('test').should be_false
  end

  it 'should cache the final result' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)
    Rails.cache.exist?('identity.1-3.identity.3-4').should be_true
  end

  it 'should cache the intermediate results' do
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)

    Rails.cache.exist?('identity.1-3').should be_true
    Rails.cache.exist?('identity.3-4').should be_true
  end

  it 'should order cache keys consistently regardless of filter order' do
    @filter_chain.include_identity('axis1', 3, 4)
    @filter_chain.include_identity('axis1', 1, 3)

    @filter_chain.include?(1)
    Rails.cache.exist?('identity.1-3.identity.3-4').should be_true
    Rails.cache.exist?('identity.3-4.identity.1-3').should be_false

    @filter_chain = FilterChain.new
    @filter_chain.include_identity('axis1', 1, 3)
    @filter_chain.include_identity('axis1', 3, 4)

    @filter_chain.include?(1)
    Rails.cache.exist?('identity.1-3.identity.3-4').should be_true
    Rails.cache.exist?('identity.3-4.identity.1-3').should be_false
  end

  it 'should recompute as needed when new filters are added' do
    @filter_chain.include_identity('axis1', 1, 2)
    @filter_chain.include?(1).should be_true
    @filter_chain.include?(3).should be_false
    @filter_chain.include_identity('axis1', 3)
    @filter_chain.include?(3).should be_true
  end

  it 'should define include and exclude methods for registered filters' do
    Filter.all_filters.each do |filter|
      @filter_chain.respond_to?("include_#{filter}").should be_true
      @filter_chain.respond_to?("exclude_#{filter}").should be_true
    end
  end

end
