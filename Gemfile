# frozen_string_literal: true

source "https://rubygems.org"

gem "bcrypt"
gem "hanami", "~> 2.3"
gem "hanami-controller", "~> 2.2"
gem "hanami-db", "~> 2.2"
gem "hanami-router", "~> 2.2"
gem "hanami-validations", "~> 2.2"
gem "hanami-view", "~> 2.2"

gem "dry-inflector"
gem "dry-operation"
gem "dry-types", "~> 1.7"
gem "pg"
gem "puma"
gem "rake"
gem "warden"

group :development do
  gem "hanami-webconsole", "~> 2.2"
  gem "rubocop", require: false
  gem "thor"
end

group :development, :test do
  gem "brakeman", ">= 7.0.2", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv"
end

group :cli, :development do
  gem "hanami-reloader", "~> 2.2"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 2.2"
end

group :test do
  # Database
  gem "database_cleaner-sequel"

  # Web integration
  gem "rack-test"
end
