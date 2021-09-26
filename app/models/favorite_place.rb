# frozen_string_literal: true

class FavoritePlace < ApplicationRecord
  belongs_to :user
  belongs_to :place
  
  validates :place_id, presence: true, uniqueness: { scope: :user_id }

  after_create :queue_update_job

  def self.cache_from_place_id_and_user_id(place_id, user_id)
    Rails.cache.fetch(FavoritePlace.cache_key_from_place_id_and_user_id(place_id, user_id)) || false
  end

  def self.cache_key_from_place_id_and_user_id(place_id, user_id)
    "favorited_#{place_id}_#{user_id}"
  end

  def add_data_from_google
    update({ data: existing_favorite_place_with_data || serialized_google_place })
  rescue StandardError
    destroy
  end

  private

  def existing_favorite_place_with_data
    FavoritePlace.where(place_id: place_id).where.not(data: nil).first
  end

  def google_place
    Google::Maps::Place.details({ place_id: place_id })['result']
  end

  def serialized_google_place
    GoogleSerializer::Place.new(google_place, { include_photo_urls: true })
  end

  def queue_update_job
    FavoritePlacesUpdateJob.perform_later self
  end

  def favorite_cache_key
    @favorite_cache_key ||= FavoritePlace.cache_key_from_place_id_and_user_id(place_id, user_id)
  end

  def add_cache
    Rails.cache.fetch(FavoritePlace.cache_key_from_place_id_and_user_id(place_id, user_id)) do
      true
    end
  end

  def remove_cache
    delete_attempts = 0

    Rails.cache.delete(favorite_cache_key) until Rails.cache.fetch(favorite_cache_key).nil? || delete_attempts > 2
  end
end
