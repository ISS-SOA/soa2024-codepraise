# frozen_string_literal: true

# load helpers in 'test' environment first
require_relative 'spec_helper'

# revert to app_test environment as DB no longer needed
ENV['RACK_ENV'] = 'app_test'

# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'
require 'page-object'
