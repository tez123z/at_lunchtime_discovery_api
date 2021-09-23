module Google
  module Maps
    class InvalidConfigurationError < StandardError; end

    # Defines constants and methods related to configuration
    module Configuration
      # An array of valid keys in the options hash when configuring an {Google::Maps::API}
      VALID_OPTIONS_KEYS = [:end_point, :format, :api_key, :default_language, :place_text_search_service,
                            :place_nearby_search_service, :required_keys, :place_details_service, :default_params, :exponential_backoff, :exponential_backoff_max_retries].freeze

      API_KEY = 'api_key'.freeze

      # Exponential backoff mentioned in best practices https://developers.google.com/maps/documentation/places/web-service/web-services-best-practices
      DEFAULT_EXPONENTIAL_BACKOFF_ENABLED = true
      DEFAULT_EXPONENTIAL_BACKOFF_MAX_RETRIES = 2

      # Default endpoint for api
      DEFAULT_END_POINT = 'https://maps.googleapis.com/maps/api/'.freeze

      # Available Services
      DEFAULT_PLACE_TEXT_SEARCH_SERVICE = 'place/textsearch'.freeze
      DEFAULT_PLACE_NEARBY_SEARCH_SERVICE = 'place/nearbysearch'.freeze
      DEFAULT_PLACE_DETAILS_SERVICE = 'place/details'.freeze

      # default format
      DEFAULT_FORMAT = 'json'.freeze

      # default language
      DEFAULT_LANGUAGE = :en

      REQUIRED_KEYS = {
        place_text_search_service: [
          :query
        ]
      }.freeze

      # @private
      attr_accessor(*VALID_OPTIONS_KEYS)

      # When this module is extended, set all configuration options to their default values
      def self.extended(base)
        base.reset
      end

      # Convenience method to allow configuration options to be set in a block
      def configure
        yield self
        validate_config
      end

      def validate_config
        raise Google::Maps::InvalidConfigurationError, 'No API key provided' unless api_key
      end

      # Create a hash of options and their values
      def options
        VALID_OPTIONS_KEYS.inject({}) do |option, key|
          option.merge!(key => send(key))
        end
      end

      # Reset all configuration options to defaults
      def reset
        self.end_point = DEFAULT_END_POINT
        self.format = DEFAULT_FORMAT
        self.place_text_search_service = DEFAULT_PLACE_TEXT_SEARCH_SERVICE
        self.place_nearby_search_service = DEFAULT_PLACE_NEARBY_SEARCH_SERVICE
        self.place_details_service = DEFAULT_PLACE_DETAILS_SERVICE
        self.default_language = DEFAULT_LANGUAGE
        self.required_keys = REQUIRED_KEYS
        self.exponential_backoff = DEFAULT_EXPONENTIAL_BACKOFF_ENABLED
        self.exponential_backoff_max_retries = DEFAULT_EXPONENTIAL_BACKOFF_MAX_RETRIES
        self.api_key = nil
        self
      end
    end
  end
end
