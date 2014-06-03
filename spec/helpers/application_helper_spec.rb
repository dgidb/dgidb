require 'spec_helper'

describe ApplicationHelper, '#dynamic_link_to' do
  it "appends an image icon to an external link" do
    url = 'http://www.google.com'
    title = 'outside'
    expect(helper.dynamic_link_to(title, url)).to eq ext_link_to(title, url)
  end

  it "does not append an image icon to an internal link" do
    url = '/internal/path.html'
    title = 'inside'
    expect(helper.dynamic_link_to(title, url)).to eq link_to(title, url)
  end
end

describe ApplicationHelper, '#ext_link_to' do
  it "appends an image icon to the link" do
    url = 'http://www.google.com'
    title = 'google'
    expect(helper.ext_link_to(title, url)).to eq link_to(title, url) + icon('share')
  end
end

describe ApplicationHelper, '#icon' do
  before :each do
    @flag_content = 'flag content'
  end

  it "returns correct markup when given a block" do
    icon_val = helper.icon( :flag ) do
      @flag_content
    end

    expect(helper.content_tag( :i, @flag_content, class: 'icon-flag' )).to eq icon_val
  end

  it "returns correct markup when given a content string" do
    expect(helper.icon( :flag, @flag_content )).to eq helper.content_tag( :i, @flag_content, class: 'icon-flag' )
  end

  it "merges class attributes correctly" do
    expect(helper.icon( :flag, class: 'test' )).to eq helper.content_tag( :i, nil, class: ['test', 'icon-flag'] )
  end
end

describe ApplicationHelper, '#tx' do
  before :each do
    @test_text = 'test'
    @test_key = 'text'
    EXTERNAL_STRINGS['test_action'] = { @test_key => @test_text }
    params = { 'action' => 'test_action' }
    allow(helper).to receive( :params ).and_return( params )
  end

  it "should lookup the correct hash value based on action and key" do
    expect(helper.tx( @test_key )).to eq @test_text
  end

  it "should return an html_safe string (unescaped)" do
    expect(helper.tx( @test_key )).to be_html_safe
  end
end

describe ApplicationHelper, '#to' do
  before :each do
    @test_obj = [ 1, 2 ,3 ]
    @test_key = 'text'
    EXTERNAL_STRINGS['test_action'] = { @test_key => @test_obj }
    params = { 'action' => 'test_action' }
    allow(helper).to receive( :params ).and_return( params )
  end

  it "should lookup the correct hash value based on action and key" do
    expect(helper.to( @test_key )).to eq @test_obj
  end
end

describe ApplicationHelper, '#label' do
  it 'should create a span with <label-given_class> and label as the classes' do
    expect(helper.label('this is a success label')).to  eq('<span class="label label-success">this is a success label</span>')
    expect(helper.label('this is a warning label', 'warning')).to  eq('<span class="label label-warning">this is a warning label</span>')
  end

  it 'should create html safe content' do
    expect(helper.label('this is a success label')).to  be_html_safe
  end
end
