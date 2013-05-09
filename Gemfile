source "https://rubygems.org"

gem "sinatra"
gem "haml"

if RUBY_PLATFORM == 'arm-linux-eabihf'
  gem "wiringpi"
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end

group :developpement do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'

  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'rb-fsevent'
    gem 'growl'
  end
end
