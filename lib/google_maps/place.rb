# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    module Place
      def self.details(parameters = {})
        API.query(:place_details_service, parameters)
      end

      def self.text_search(parameters = {})
        API.query(:place_text_search_service, parameters)
      end

      def self.photo_url(parameters = {})
        API.url(:place_photo_service, parameters)
      end
    end
  end
end
