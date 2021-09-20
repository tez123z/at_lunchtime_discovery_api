class GooglePlacesController < ApplicationController
  before_action :validate_search_params

  def search
    
    result = GoogleServices::PlacesSearch.call(search_params)

    if result.success?
      render json: result.payload, status: :ok
    else
      render json:{errors:result.errors}, status: :unprocessable_entity
    end

  end

  private
  
    def validate_search_params
      param! :query, String, required: true
      param! :language, String, in: $GOOGLE_SUPPORTED_LANGUAGE_CODES
      param! :location, String, message: "Please provide valid format for location. ex. 34.885323897514056,-82.41706436684173", format: /^\s*[-+]?\d{1,3}\.\d+\,\s?[-+]?\d{1,3}\.\d+\s*$/
      param! :maxprice, Integer, in: [0..4]
      param! :minprice, Integer, in: [0..4]
      param! :opennow, :boolean
      param! :pagetoken, String
      param! :radius, Integer, max:50000
      param! :type, String, in: $GOOGLE_PLACE_TYPES
    end

    def search_params

      params.permit(
        :query,
        :language,
        :location,
        :maxprice,
        :minprice,
        :opennow,
        :pagetoken,
        :radius,
        :region,
        :type
      )
    end

end
