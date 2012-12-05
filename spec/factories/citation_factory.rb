FactoryGirl.define do
  factory :citation, class: DataModel::Citation do
    source_db_name 'Source DB'
    source_db_version '31-Feb-2012'
    citation 'longform citation text would be here, its pretty cool'
    base_url 'http://example.com/search_path?q='
    site_url 'http://example.com/'
    full_name 'The source database'
  end
end