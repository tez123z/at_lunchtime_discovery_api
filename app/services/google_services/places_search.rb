require "uri"
require "net/http"

module GoogleServices

  class PlacesSearch < ApplicationService
    
    attr_reader :search_params, :include_photo_links

    $MAX_RETRIES = 5
    $API_KEY = "AIzaSyD96aOje6CXjw18dHjIzBenm1ZcurKvRNA"
    $DEFAULT_SEARCH_PARAMS = { type: "restaurant" }
    
    def initialize(search_params, include_photo_links = true)
      @search_params = $DEFAULT_SEARCH_PARAMS.merge(search_params)
      @include_photo_links = include_photo_links
    end

    def call

      retries = 0
      
      begin

        url = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?#{@search_params.to_query}&key=#{api_key}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)

        response = https.request(request)
        results = JSON.parse(response.body)["results"]

        results = add_photo_urls_to_results(results) if @include_photo_links
        
        OpenStruct.new({success?: true, payload: results})

      rescue => e

        puts e
        
        if retries <= $MAX_RETRIES
          
          retries += 1
          sleep 2 ** retries
          retry

        else
          
          OpenStruct.new({success?: false, errors: [e]})

        end

      end

    end

    def add_photo_urls_to_results(results, maxwidth = 400)
      results.each do |r| 
        r["photos"].each do |p| 
          p["photo_url"] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{400}&photo_reference=#{p["photo_reference"]}&key=#{api_key}" 
        end
      end
    end

    private

      def api_key
        ENV['GOOGLE_API_KEY'] || $API_KEY 
      end

  end
  
end