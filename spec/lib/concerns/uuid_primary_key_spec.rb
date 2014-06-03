require 'spec_helper'

describe Genome::Extensions::UUIDPrimaryKey do
  it 'should set generate a uuid automatically' do
    s = Fabricate(:source)
    expect(s.id).not_to be(nil)
  end

  it 'should not override a given uuid' do
    id = SecureRandom.uuid
    s = Fabricate(:source, id: id)

    expect(s.id).to eq(id)
  end
end
