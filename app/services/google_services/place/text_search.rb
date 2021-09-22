# frozen_string_literal: true

module GoogleServices
  module Place
    class TextSearch < ApiService
      attr_reader :search_params

      EXPONENTIAL_BACKOFF_EXCEPTIONS = [GatewayTimeoutError, ServerError].freeze
      MAX_RETRIES = 2
      DEFAULT_SEARCH_PARAMS = { type: 'restaurant' }.freeze

      def initialize(search_params)
        raise MissingAPICredentials, 'Missing credentials GOOGLE_API_KEY ' if GOOGLE_API_KEY.blank?

        @search_params = DEFAULT_SEARCH_PARAMS.merge(search_params)
      end

      def call
        retries = 0

        begin
          results = Rails.cache.fetch("google_places_search_#{@search_params.to_query}", expires_in: 24.hours) do
            request(http_method: 'GET', url: "https://maps.googleapis.com/maps/api/place/textsearch/json?#{@search_params.to_query}&key=#{GOOGLE_API_KEY}")
          end

          OpenStruct.new({ success?: true, payload: results['results'] })
        rescue *EXPONENTIAL_BACKOFF_EXCEPTIONS => e
          puts e

          if retries <= MAX_RETRIES

            retries += 1
            sleep 2**retries
            retry

          else

            OpenStruct.new({ success?: false, errors: { error: [e.message] } })

          end
        rescue StandardError => e
          OpenStruct.new({ success?: false, errors: { error: [e.message] } })
        end
      end
    end
  end
end
