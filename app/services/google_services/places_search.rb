require "uri"
require "net/http"

module GoogleServices

  class PlacesSearch < ApplicationService
    
    attr_reader :search_params, :include_photo_links

    MAX_RETRIES = 5
    DEFAULT_SEARCH_PARAMS = { type: "restaurant" }
    
    def initialize(search_params, include_photo_links = true)
      @search_params = DEFAULT_SEARCH_PARAMS.merge(search_params)
    end

    def call

      retries = 0
      
      begin

        url = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?#{@search_params.to_query}&key=#{GOOGLE_API_KEY}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)

        response = https.request(request)
        results = JSON.parse(response.body)["results"]
        
        OpenStruct.new({success?: true, payload: results})

      rescue => e

        puts e
        
        if retries <= MAX_RETRIES
          
          retries += 1
          sleep 2 ** retries
          retry

        else
          
          OpenStruct.new({success?: false, errors: [e]})

        end

      end

    end

  end
  
end