require 'spec_helper'

describe 'interactions' do

  it 'Looks reasonable' do
    interaction = Fabricate(:interaction)
    visit ['/interactions', interaction.id].join('/')
    expect(page.status_code).to eq(200)
  end

  it 'Has expected attributes' do
    interaction = Fabricate(:interaction)
    expect(interaction.source_names).not_to be_empty
    expect(interaction.type_names).not_to be_empty
    expect(interaction.pmids).not_to be_empty
  end

end
