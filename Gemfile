source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.1"

gem "rails", "~> 7.2"
gem "sqlite3", ">= 2.0"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Claude API
gem "anthropic", "~> 0.3"

# HTTP client for Slack webhook
gem "faraday", "~> 2.0"

# Environment variables
gem "dotenv-rails", groups: [:development, :test]

# Pagination
gem "kaminari"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end
