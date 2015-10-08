source 'https://rubygems.org'
ruby '2.1.1'

gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass', '~> 3.1.1.1'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem 'fabrication', '2.14.1'
  gem 'faker', '1.5.0'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', '~> 2.8.0', require: false
end

group :production do
  gem 'rails_12factor'
end

