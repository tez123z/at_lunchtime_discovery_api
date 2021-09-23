# frozen_string_literal: true

class GooglePlacesController < ApplicationController
  before_action :authenticate_user!

  def search
    result = GoogleServices::Place::TextSearch.call(search_params)

    if result.success?

      results, next_page_token = result.payload

      place_ids = results.map { |p| p['place_id'] }
      favorite_place_ids = current_user.favorite_places.where(place_id: place_ids).pluck(:place_id)

      serialized_results = GoogleSerializer::Place.new(results, {
                                                         include_photo_urls: true,
                                                         favorite_place_ids: favorite_place_ids,
                                                         sort_by_ratings: sorting_param
                                                       })

      render json: { data: serialized_results, next_page_token: next_page_token }, status: :ok
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.permit(:query, :location, :radius, :sort_by_ratings, :pagetoken)
  end

  def sorting_param
    params[:sort_by_ratings]
  end
end
