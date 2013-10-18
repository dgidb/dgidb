require 'spec_helper'

describe Genome::Extensions::UUIDPrimaryKey do
  it 'should set generate a uuid automatically' do
    s = Fabricate(:source)
    s.id.should_not be(nil)
  end

  it 'should not override a given uuid' do
    id = SecureRandom.uuid
    s = Fabricate(:source, id: id)

    s.id.should eq(id)
  end
end
