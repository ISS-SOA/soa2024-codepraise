# frozen_string_literal: true

require 'roda'
require 'yaml'

module CodePraise
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    GH_TOKEN = CONFIG['GITHUB_TOKEN']
  end
end
