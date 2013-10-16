require 'spec_helper'

class DefaultRow < Genome::Importers::DelimitedRow
  attribute :column_1
  attribute :column_2
  attribute :column_3, Array
end

class CustomParser < Genome::Importers::DelimitedRow
  attribute :upcased_thing, String, parser: ->(x) { x.upcase }
end

class CustomDelimiter < Genome::Importers::DelimitedRow
  attribute :delimited_thing, Array, delimiter: '|'
end

describe Genome::Importers::DelimitedRow do

  it 'should define an accessor method for each attribute' do
    default_row = DefaultRow.new("hello\tworld\t!")
    default_row.should respond_to(:column_1)
    default_row.should respond_to(:column_2)
    default_row.should respond_to(:column_3)
  end

  it 'should default to tab delimited rows' do
    default_row = DefaultRow.new("hello\tworld\tone,two")
    default_row.column_1.should eq('hello')
    default_row.column_2.should eq('world')
    default_row.column_3.should eq(['one', 'two'])
  end

  it 'should throw an error if the column numbers do not match' do
    expect { DefaultRow.new("hello\tworld") }.to raise_error
  end

  it 'should not drop trailing empty columns' do
    default_row = DefaultRow.new("hello\t\t")
    default_row.column_1.should eq('hello')
    default_row.column_2.should eq('')
    default_row.column_3.should eq([])
  end

  it 'should accept String or Array types, but no others' do
    expect {
      class InvalidType < Genome::Importers::DelimitedRow
        attribute :foo, Integer
      end
    }.to raise_error
  end

  it 'should accept a custom delimiter for Array columns' do
  end

  it 'should allow a custom parser to be supplied' do
    lower_val = 'foobar'
    custom_parser = CustomParser.new(lower_val)
    custom_parser.upcased_thing.should eq(lower_val.upcase)
  end

  it 'should strip trailing and leading whitespace by default' do
    test_string = 'one|two|three'
    custom_delimiter = CustomDelimiter.new(test_string)
    custom_delimiter.delimited_thing.should eq(test_string.split('|'))
  end

end


