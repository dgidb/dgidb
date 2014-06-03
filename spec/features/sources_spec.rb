require 'spec_helper'

describe 'sources' do
  it 'loads successfully' do
    visit '/sources'
    expect(page.status_code).to eq (200)
  end

  it 'displays a list of sources in the database' do
    sources = (1..3).map { Fabricate(:source) }
    visit '/sources'

    sources.each do |source|
      expect(page).to have_content(source.source_db_name)
    end
  end

end
