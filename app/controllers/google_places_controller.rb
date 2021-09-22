# frozen_string_literal: true

class GooglePlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_search_params

  def search
    result = GoogleServices::Place::TextSearch.call(search_params)

    if result.success?

      serialized_results = GoogleSerializer::Place.new(result.payload, {
                                                         include_photo_urls: true,
                                                         user_id: current_user.id,
                                                         include_favorites: true
                                                       })

      render json: serialized_results.to_hash, status: :ok

    else

      render json: result.errors, status: :unprocessable_entity

    end
  end

  private

  def validate_search_params
    param! :query, String, required: true
    param! :language, String, in: GOOGLE_SUPPORTED_LANGUAGE_CODES
    param! :location, String, format: /^\s*[-+]?\d{1,3}\.\d+,\s?[-+]?\d{1,3}\.\d+\s*$/
    param! :maxprice, Integer, in: [0..4]
    param! :minprice, Integer, in: [0..4]
    param! :opennow, :boolean
    param! :pagetoken, String
    param! :radius, Integer, max: 50_000
    param! :type, String, in: GOOGLE_PLACE_TYPES
  end

  def search_params
    params.require(:google_place).permit(
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
