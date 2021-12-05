# frozen_string_literal: true

require 'figaro'
require 'logger'
require 'rack/session'
require 'roda'

module CodePraise
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    # Logger Setup
    @logger = Logger.new($stderr)
    class << self
      attr_reader :logger
    end

    # Debugging Tools
    configure :development, :test, :app_test do
      require 'pry'
    end
  end
end
