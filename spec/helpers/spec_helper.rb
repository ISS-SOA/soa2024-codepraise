# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'

require_relative '../../require_app'
require_app

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
GH_URL = 'http://github.com/soumyaray/YPBT-app'

# Helper method for acceptance tests
# - deliberately using a :reek:UtilityFunction for testing
def homepage
  CodePraise::App.config.APP_HOST
end
