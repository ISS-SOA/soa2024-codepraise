# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    # Contributor to a Git-based Project
    class Contributor < Dry::Struct
      include Dry.Types

      attribute :username,  Strict::String
      attribute :email,     Strict::String

      # Email address defines uniqueness
      def ==(other)
        (email == other.email) || (username == other.username)
      end

      # Redefine hashing (hash uses eql?)
      alias eql? ==

      # Favor email for unique identifier (hash key)
      def hash
        email.hash
      end
    end
  end
end
