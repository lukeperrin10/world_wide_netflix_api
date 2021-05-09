source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors', require: 'rack/cors'
gem 'rest-client'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'geocoder'
gem 'devise_token_auth'
gem 'pundit'
gem 'stripe-rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'coveralls', require: false
  gem 'webmock'
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end
