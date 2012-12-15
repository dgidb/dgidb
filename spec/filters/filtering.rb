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
  end

  it 'should combine exlusive only filters accurately' do
  end

  it 'should combine inclusive and exclusive filters accurately' do
  end

  it 'should not break when given no filters' do
    @filter_chain.include?('test').should be_false
  end

  it 'should cache the final result' do
  end

  it 'should cache the intermediate results' do
  end

  it 'should order cache keys consistently regardless of filter order' do
  end

  it 'should recompute as needed when new filters are added' do
  end

  it 'should define both include and exclude methods for registered filters' do
    Filter.all_filters.each do |filter|
      #@filter_chain.respond_to?("include_#{filter}").should be_true
      #@filter_chain.respond_to?("exclude_#{filter}").should be_true
    end
  end
end
