require 'spec_helper'
include Genome::Extensions

describe Genome::Extensions::NullObject do

  it 'should be chainable - all method calls should return itself' do
    obj = NullObject.new

    expect(obj.something.anything.another_method).to be(obj)
  end

  it 'should give relevant values for common conversions' do
    obj = NullObject.new

    expect(obj.to_str).to eq(0)
    expect(obj.to_s).to eq(0)
    expect(obj.nil?).to be true
    expect(obj.exist?('')).to be false
  end

  describe 'Maybe' do
    it 'should return a new NullObject if the argument is nil' do
      expect(Maybe(nil)).to be_a(NullObject)
    end

    it 'should return the argument if it isnt nil' do
      expect(Maybe(1)).to be_a(Fixnum)
      expect(Maybe(1)).to eq(1)
    end
  end
end
