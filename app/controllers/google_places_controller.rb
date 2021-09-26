# frozen_string_literal: true

class GooglePlacesController < ApplicationController
  before_action :authenticate_user!

  def search
    
    result = GoogleServices::Place::TextSearch.call(search_params)

    if result.success?
      @results, @next_page_token = result.payload
      render json: {data: sorted_places, next_page_token: next_page_token }, status: :ok
    else
      render json: result.errors, status: :unprocessable_entity
    end

  end

  private

  attr_accessor :results, :next_page_token

  def places
    GoogleSerializer::Places.new(results,current_user.id).results
  end

  def sorted_places
    if sorting_param
      places.sort do |a, b|
        if sorting_param.casecmp('asc').zero?
          a[:rating] <=> b[:rating]
        else
          b[:rating] <=> a[:rating]
        end
      end
    else
      places
    end
  end

  def search_params
    params.permit(:query, :location, :radius, :sort_by_ratings, :pagetoken)
  end

  def sorting_param
    params[:sort_by_ratings]
  end
end
