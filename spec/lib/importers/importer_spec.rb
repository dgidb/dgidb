require 'spec_helper'

describe Genome::Importers::Importer do

  before :each do
    @importer = Genome::Importers::Importer.new({source_db_name: 'test'})
  end

  it 'should respond to creation method calls for each entity name' do
    @importer.send(:entity_names).each do |entity_name|
      @importer.send("create_#{entity_name}", {blah: 1}).should be_true
    end
    expect { @importer.create_something_fake({blah: 1}) }.to raise_error
  end

  it 'should return the id of the newly created entity as a uuid string when create_* is called' do
    id = @importer.create_gene_claim({name: 'test gene'})
    id.should be_a(String)
    id.match(/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/).should be_true
  end

  it 'should de-duplicate identical entites' do
    info = { name: 'turkey', nomenclature: 'sandwiches' }
    second_info = info.dup
    first_id = @importer.create_gene_claim(info)
    second_id = @importer.create_gene_claim(second_info)

    first_id.should eq(second_id)
  end

  it 'should allow for an id to be passed in without overidding it' do
    test_id = 'test_id'
    info = { name: 'turkey', nomenclature: 'sandwiches', id: test_id }
    id = @importer.create_gene_claim(info)
    id.should eq(test_id)
  end

  it 'should create a source from the passed in hash' do
    source = @importer.instance_variable_get("@source")
    source.should be_a(DataModel::Source)
    source.source_db_name.should eq('test')
  end

  it 'should allow an existing source to be passed in' do
    source = Fabricate(:source)
    importer = Genome::Importers::Importer.new({}, source)
    importer.instance_variable_get("@source").should eq(source)
  end

  it 'should save the created entities to the database when store is called' do
    importer = Genome::Importers::Importer.new({}, Fabricate(:source))
    importer.create_gene_claim({ name: 'test gene claim 1', nomenclature: 'test 1'})
    importer.create_gene_claim({ name: 'test gene claim 2', nomenclature: 'test 2'})
    importer.store
    db_claims = DataModel::GeneClaim.all
    db_claims.size.should eq(2)
    db_claims.map(&:name).sort.should eq(['test gene claim 1', 'test gene claim 2'])
  end

  it 'should link the created entities to the created source' do
    source = Fabricate(:source)
    importer = Genome::Importers::Importer.new({}, source)
    importer.create_gene_claim({ name: 'test gene claim 1', nomenclature: 'test 1'})
    importer.store
    DataModel::GeneClaim.first.source.should eq(source)
  end

end
