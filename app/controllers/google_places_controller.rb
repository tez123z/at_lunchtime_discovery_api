# frozen_string_literal: true

class GooglePlacesController < ApplicationController
  before_action :authenticate_user!

  def search
    
    result = GoogleServices::Place::TextSearch.call(search_params)

    if result.success?
      results,next_page_token = result.payload
      serialized_results = GoogleSerializer::Place.new(results, {include_photo_urls: true,user_id: current_user.id,include_favorites: true})
      render json: {data:serialized_results,next_page_token:next_page_token}, status: :ok
    else
      render json: result.errors, status: :unprocessable_entity
    end

  end

  private

  def search_params
    params.permit(:query, :location, :radius, :sort_by_ratings, :pagetoken)
  end

end
