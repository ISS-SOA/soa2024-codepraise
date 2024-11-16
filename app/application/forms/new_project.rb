# frozen_string_literal: true

require 'dry-validation'

module CodePraise
  module Forms
    # Form validation for Github project URL
    class NewProject < Dry::Validation::Contract
      URL_REGEX = %r{(http[s]?)://(www.)?github\.com/.*/.*(?<!git)$}
      MSG_INVALID_URL = 'is an invalid address for a Github project'

      params do
        required(:remote_url).filled(:string)
      end

      rule(:remote_url) do
        key.failure(MSG_INVALID_URL) unless URL_REGEX.match?(value)
      end
    end
  end
end
