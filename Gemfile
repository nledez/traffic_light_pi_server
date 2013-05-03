source "https://rubygems.org"

gem "sinatra"
gem "haml"

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'

  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'rb-fsevent'
    gem 'growl'
  end
end
