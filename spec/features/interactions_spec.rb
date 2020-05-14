require 'spec_helper'

describe 'interactions' do

  it 'Interaction looks reasonable' do
    interaction = Fabricate(:interaction)
    visit ['/interactions', interaction.id].join('/')
    expect(page.status_code).to eq(200)
  end
end
