require 'spec_helper'
include Genome::Extensions

describe Genome::Extensions::NullObject do

  it 'should be chainable - all method calls should return itself' do
    obj = NullObject.new

    obj.something.anything.another_method.should be(obj)
  end

  it 'should give relevant values for common conversions' do
    obj = NullObject.new

    obj.to_str.should eq(0)
    obj.to_s.should eq(0)
    obj.nil?.should be_true
    obj.exist?('').should be_false
  end

  describe 'Maybe' do
    it 'should return a new NullObject if the argument is nil' do
      Maybe(nil).should be_a(NullObject)
    end

    it 'should return the argument if it isnt nil' do
      Maybe(1).should be_a(Fixnum)
      Maybe(1).should eq(1)
    end
  end
end
