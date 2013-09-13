require 'spec_helper'

describe '/api' do
  it 'should load with a valid 200 status code' do
    visit '/api'
    page.status_code.should eq(200)
  end
end