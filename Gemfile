source "https://rubygems.org"

ruby "3.0.0"

gem "rails", "~> 6.1.1"
gem "puma"
gem "docker-api"
gem "redis"

group :development, :test do
  # Rubocop
  gem "standardrb", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rubycw", require: false
  gem "rubocop-performance", require: false

  # RSpec
  gem "rspec-rails", require: false
end

group :test do
  gem "committee-rails"
end
