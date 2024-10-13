# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/github_api'

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
CONFIG = YAML.safe_load_file('config/secrets.yml')
GITHUB_TOKEN = CONFIG['GITHUB_TOKEN']
CORRECT = YAML.safe_load_file('spec/fixtures/github_results.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'github_api'
