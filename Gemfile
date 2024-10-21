# frozen_string_literal: true

source 'https://rubygems.org'

# Configuration and Utilities
gem 'figaro', '~> 1.0'
gem 'pry'
gem 'rake'

# Web Application
gem 'logger', '~> 1.6'
gem 'puma', '~> 6.4'
gem 'roda', '~> 3.85'
gem 'slim', '~> 5.2'

# Data Validation
gem 'dry-struct', '~> 1.6'
gem 'dry-types', '~> 1.7'

# Networking
gem 'http', '~> 5.0'

# Database
gem 'hirb'
# gem 'hirb-unicode' # incompatible with new rubocop
gem 'sequel', '~> 5.0'

group :development, :test do
  gem 'sqlite3', '~> 1.0'
end

# Testing
group :test do
  gem 'minitest', '~> 5.20'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'
end

# Development
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-rake'
  gem 'rubocop-sequel'
end
