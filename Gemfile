source 'https://rubygems.org'

gem 'rails', '~> 6.0.3'

gem 'browser'
gem 'pg', '~>1.2.3'
# Using forked copy until https://github.com/metaskills/less-rails-bootstrap/pull/132 is merged
gem 'less-rails-bootstrap', git: 'https://github.com/veelenga/less-rails-bootstrap',
    ref: '7c479c2fdff500dc036c15364aa085332a73c642'
gem 'nokogiri'
gem 'haml'
gem 'textacular', require: 'textacular/rails'
gem 'jquery-rails'
gem 'therubyracer'
gem 'libv8'
gem 'exception_notification'
gem 'rake'
gem 'xpath'
gem 'jbuilder'
gem 'lograge'
gem 'syslog-logger'
gem 'rye'
gem 'delayed_job', '~> 4.1.4'
gem 'delayed_job_active_record'
gem 'rubyzip'
gem 'kaminari', '~> 0.16.1'
gem 'sidekiq', '~> 6.0.3'
gem 'sidekiq-cron', '~> 1.1.0'
gem 'airbrake', '~> 10.0.5'


group :production do
  gem 'dalli'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rack-mini-profiler'
  gem 'rails-erd'
  gem 'capistrano', '~> 3.9.0'
  gem 'capistrano-bundler', '~> 1.6'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-passenger', '~> 0.2.0'
end

group :test, :development  do
  gem 'rspec-rails'
  gem 'fabrication'
  gem "capybara"
  gem "launchy"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'activerecord-import'
  gem 'stamp'
  gem 'database_cleaner'
  gem 'coveralls'
  gem 'test-unit'
end

