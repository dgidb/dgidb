require 'spec_helper'

describe ApplicationHelper, '#icon' do

  before :each do
    @flag_content = 'flag content'
  end

  it "returns correct markup when given a block" do
    icon_val = helper.icon( :flag ) do
      @flag_content
    end

    helper.content_tag( :i, @flag_content, class: 'icon-flag' ).should eq icon_val
  end

  it "returns correct markup when given a content string" do
    helper.icon( :flag, @flag_content ).should eq helper.content_tag( :i, @flag_content, class: 'icon-flag' )
  end

  it "merges class attributes correctly" do
    helper.icon( :flag, class: 'test' ).should eq helper.content_tag( :i, nil, class: ['test', 'icon-flag'] )
  end

end


describe ApplicationHelper, '#tx' do

  before :each do
    @test_text = 'test'
    @test_key = 'text'
    EXTERNAL_STRINGS['test_action'] = { @test_key => @test_text }
    params = { 'action' => 'test_action' }
    helper.stub( :params ).and_return( params )
  end

  it "should lookup the correct hash value based on action and key" do
    helper.tx( @test_key ).should eq @test_text
  end

  it "should return an html_safe string (unescaped)" do
    helper.tx( @test_key ).should be_html_safe
  end

end


describe ApplicationHelper, '#to' do

  before :each do
    @test_obj = [ 1, 2 ,3 ]
    @test_key = 'text'
    EXTERNAL_STRINGS['test_action'] = { @test_key => @test_obj }
    params = { 'action' => 'test_action' }
    helper.stub( :params ).and_return( params )
  end

  it "should lookup the correct hash value based on action and key" do
    helper.to( @test_key ).should eq @test_obj
  end

end
