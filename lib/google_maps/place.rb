# frozen_string_literal: true

require File.expand_path('api', __dir__)

module Google
  module Maps
    module Place
      def self.text_search(parameters = {})
        API.query(:place_text_search_service, parameters)
      end
    end
  end
end
