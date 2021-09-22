# frozen_string_literal: true

class FavoritePlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favorite_place, only: [:show, :update, :destroy]

  # GET /favorite_places
  def index
    @favorite_places = current_user.favorite_places.all

    render json: @favorite_places
  end

  # GET /favorite_places/1
  def show
    render json: @favorite_place
  end

  # POST /favorite_places
  def create
    @favorite_place = current_user.favorite_places.build(favorite_place_params)

    if @favorite_place.save
      render json: @favorite_place, status: :created, location: @favorite_place
    else
      render json: @favorite_place.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorite_places/1
  def update
    render json: @favorite_place
  end

  # DELETE /favorite_places/1
  def destroy
    @favorite_place.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite_place
    @favorite_place = current_user.favorite_places.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def favorite_place_params
    params.require(:favorite_place).permit(:place_id)
  end
end
