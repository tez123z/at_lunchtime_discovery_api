module GoogleServices
  module Place
    class TextSearch < ApiService

      attr_reader :search_params

      EXPONENTIAL_BACKOFF_EXCEPTIONS = [GatewayTimeoutError, ServerError]
      MAX_RETRIES = 2
      DEFAULT_SEARCH_PARAMS = { type: "restaurant" }.freeze
      
      def initialize(search_params)
        @search_params = DEFAULT_SEARCH_PARAMS.merge(search_params)
      end

      def call

        retries = 0
        
        begin

          results = Rails.cache.fetch("google_places_search_#{@search_params.to_query}", expires_in:24.hours) {
            request(http_method:"GET",url:"https://maps.googleapis.com/maps/api/place/textsearch/json?#{@search_params.to_query}&key=#{GOOGLE_API_KEY}")
          }
          
          OpenStruct.new({success?: true, payload: results["results"]})

        rescue *EXPONENTIAL_BACKOFF_EXCEPTIONS => e

          puts e
          
          if retries <= MAX_RETRIES
            
            retries += 1
            sleep 2 ** retries
            retry

          else
            
            OpenStruct.new({success?: false, errors: {error:[e.message]}})

          end
        
        rescue => e
          
          OpenStruct.new({success?: false, errors: {error:[e.message]}})

        end

      end
    
    end

  end
  
end