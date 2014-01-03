source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'pg'
gem 'less-rails-bootstrap'
gem 'nokogiri'
gem 'haml'
gem 'textacular', require: 'textacular/rails'
gem 'jquery-rails', '2.1.4'
gem 'therubyracer', '~> 0.11.1'
gem 'libv8', '~> 3.11.8.3', :platform => :ruby
gem 'less-rails'
gem 'exception_notification'
gem 'rake'
gem 'xpath'
gem 'jbuilder'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'feedback_popup', git: 'git://github.com/acoffman/feedback_popup.git'
gem 'lograge', git: 'https://github.com/roidrage/lograge.git'
gem 'syslog-logger'
gem 'rye'

group :production do
  gem 'dalli'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'rack-mini-profiler'
end

group :test, :development  do
  gem 'rspec-rails'
  gem 'fabrication'
  gem "capybara"
  gem "launchy"
  gem 'better_errors'
  gem 'binding_of_caller', '~> 0.7.0'
  gem 'activerecord-import'
  gem 'stamp'
  gem 'database_cleaner'
  gem 'coveralls'
end

