require 'spec_helper'

describe 'news' do

  before :all do
    Fabricate(:source_type, type: 'interaction')
    date_stamp = Date.today.stamp('April 1, 2013')
    EXTERNAL_STRINGS['news']['posts'] = [{'headline' => 'test', 'article' => 'test', 'date' => date_stamp }]
  end

  it 'loads succesfully' do
    visit '/news'
    expect(page.status_code).to eq (200)
  end

  it 'should display an alert when there is unread news' do
    visit '/'
    expect(find('.dropdown-toggle')).to have_content("Help !")
  end

  it 'should clear the alert once news has been read' do
    visit '/'
    expect(find('.dropdown-toggle')).to have_content("Help !")
    visit '/news'
    expect(find('.dropdown-toggle')).not_to have_content("Help !")
    visit '/'
    expect(find('.dropdown-toggle')).not_to have_content("Help !")
  end

  it 'should set a cookie containing the recent post date when the news page is visited' do
    visit '/news'
    expect(Date.parse(cookie_jar['most_recent_post_date'])).to eq(Date.parse(EXTERNAL_STRINGS['news']['posts'].last['date']))
  end

  it 'should not display an alert if there is a cookie set with a date >= the most recent post' do
    cookie_jar['most_recent_post_date'] = Date.today.next
    visit '/'
    expect(find('.dropdown-toggle')).not_to have_content("Help !")
  end

end
