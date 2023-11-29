source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem "slim-rails"
gem 'devise'
gem 'carrierwave'
gem 'cocoon'
gem 'gon'
gem 'responders'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-rails_csrf_protection'
gem 'pundit'
gem 'webrick'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'whenever'
gem 'sinatra', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'database_cleaner-active_record'
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'webdrivers'
  gem 'rails-controller-testing'
  gem 'pundit-matchers', '~> 3.1'
  gem 'json_spec'  
end
