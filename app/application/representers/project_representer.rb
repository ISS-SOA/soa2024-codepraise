# frozen_string_literal: true

require 'ostruct'
require 'roar/decorator'
require 'roar/json'

require_relative 'member_representer'

# Represents essential Repo information for API output
module CodePraise
  module Representer
    # Represent a Project entity as Json
    class Project < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :origin_id
      property :name
      property :ssh_url
      property :http_url
      property :fullname
      property :size
      property :owner, extend: Representer::Member, class: OpenStruct
      collection :contributors, extend: Representer::Member, class: OpenStruct

      link :self do
        "#{api_host_url}/api/v1/projects/#{project_name}/#{owner_name}"
      end

      private

      def api_host_url
        ENV.fetch('API_HOST', nil)
      end

      def project_name
        represented.name
      end

      def owner_name
        represented.owner.username
      end
    end
  end
end
