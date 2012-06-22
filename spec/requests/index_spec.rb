require 'spec_helper'

describe 'index' do
  it 'check to see if the page exists' do
    visit '/'
    page.status_code.should eq(200)
    page.should have_content('DGIDB')
  end
end
