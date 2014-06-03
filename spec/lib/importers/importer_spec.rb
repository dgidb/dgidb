require 'spec_helper'

describe Genome::Importers::Importer do

  before :each do
    @importer = Genome::Importers::Importer.new({source_db_name: 'test'})
  end

  it 'should respond to creation method calls for each entity name' do
    @importer.send(:entity_names).each do |entity_name|
      expect(@importer.send("create_#{entity_name}", {blah: 1})).to be_truthy
    end
    expect { @importer.create_something_fake({blah: 1}) }.to raise_error
  end

  it 'should return the id of the newly created entity as a uuid string when create_* is called' do
    id = @importer.create_gene_claim({name: 'test gene'})
    expect(id).to be_a(String)
    expect(id.match(/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/)).to be_truthy
  end

  it 'should de-duplicate identical entites' do
    info = { name: 'turkey', nomenclature: 'sandwiches' }
    second_info = info.dup
    first_id = @importer.create_gene_claim(info)
    second_id = @importer.create_gene_claim(second_info)

    expect(first_id).to eq(second_id)
  end

  it 'should allow for an id to be passed in without overidding it' do
    test_id = 'test_id'
    info = { name: 'turkey', nomenclature: 'sandwiches', id: test_id }
    id = @importer.create_gene_claim(info)
    expect(id).to eq(test_id)
  end

  it 'should create a source from the passed in hash' do
    source = @importer.instance_variable_get("@source")
    expect(source).to be_a(DataModel::Source)
    expect(source.source_db_name).to eq('test')
  end

  it 'should allow an existing source to be passed in' do
    source = Fabricate(:source)
    importer = Genome::Importers::Importer.new({}, source)
    expect(importer.instance_variable_get("@source")).to eq(source)
  end

  it 'should save the created entities to the database when store is called' do
    importer = Genome::Importers::Importer.new({}, Fabricate(:source))
    importer.create_gene_claim({ name: 'test gene claim 1', nomenclature: 'test 1'})
    importer.create_gene_claim({ name: 'test gene claim 2', nomenclature: 'test 2'})
    importer.store
    db_claims = DataModel::GeneClaim.all
    expect(db_claims.size).to eq(2)
    expect(db_claims.map(&:name).sort).to eq(['test gene claim 1', 'test gene claim 2'])
  end

  it 'should link the created entities to the created source' do
    source = Fabricate(:source)
    importer = Genome::Importers::Importer.new({}, source)
    importer.create_gene_claim({ name: 'test gene claim 1', nomenclature: 'test 1'})
    importer.store
    expect(DataModel::GeneClaim.first.source).to eq(source)
  end

end
