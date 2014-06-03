require 'spec_helper'

describe '/api' do
  it 'should load with a valid 200 status code' do
    visit '/api'
    expect(page.status_code).to eq(200)
  end
end