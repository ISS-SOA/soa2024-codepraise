# frozen_string_literal: true

# load helpers in 'test' environment first
require_relative 'spec_helper'
require_relative 'database_helper'
require_relative 'vcr_helper'

# revert to app_test environment as DB no longer needed
ENV['RACK_ENV'] = 'app_test'

# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'
require 'page-object'

# require_relative '../../helpers/spec_helper'
# require_relative '../../helpers/database_helper'
# require_relative '../../helpers/vcr_helper'

# # require 'headless'
# require 'webdrivers/chromedriver'
# require 'watir'
