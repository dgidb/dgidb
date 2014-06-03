require 'spec_helper'


class EnumerableTypeMockBase

  #next two methods stub out active record methods
  def self.all
    type = 'ABC'
    name = 'A B C'
    (1..10).map { |id| TestRecord.new(id, type.next!.dup, name.next!.dup) }
  end

  def self.inheritance_column=(arg)
  end

  include Genome::Extensions::EnumerableType
  def self.enumerable_cache_key
    'enumerable_type_mock_base'
  end

  TestRecord = Struct.new(:id, :type, :name)
end

class EnumerableTypeWithMultipleTransForms < EnumerableTypeMockBase
  def self.transforms
    [:downcase, [:gsub, ' ', '_']]
  end

  def self.type_column
    :name
  end

  def self.enumerable_cache_key
    'enumerable_type_mock_multiple'
  end
end


describe 'EnumerableType concern' do
  before :each do
    Rails.cache.clear
  end

  it 'should allow you to call a class method with a type name' do
    expect(EnumerableTypeMockBase.ABD).to eq(1)
  end

  it 'should transform the type column appropriately' do
    #apply all transforms, transforms with arguments
    #multiple transforms
    expect(EnumerableTypeMockBase.abd).to eq(1)
    expect(EnumerableTypeWithMultipleTransForms.A_B_D).to eq(1)
  end

  it 'should cache the value of all_types after the first call' do
    expect(EnumerableTypeMockBase.ABD).to eq(1)
    expect(Rails.cache.exist?('enumerable_type_mock_base')).to be true
  end

  it 'should pass methods that are not types along to super' do
    expect { EnumerableTypeMockBase.BLAH }.to raise_error(NoMethodError)
  end

  it 'should return the id of the appropriate item' do
    method = 'ABC'
    (1..10).each do |num|
      expect(EnumerableTypeMockBase.send(method.next!.dup.to_sym)).to eq(num)
    end
  end
end
