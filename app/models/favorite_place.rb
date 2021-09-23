# frozen_string_literal: true

class FavoritePlace < ApplicationRecord
  belongs_to :user

  validates :place_id, presence: true, uniqueness: { scope: :user_id }

  after_create :add_cache
  after_destroy :remove_cache

  def self.cache_from_place_id_and_user_id(place_id, user_id)
    Rails.cache.fetch(FavoritePlace.cache_key_from_place_id_and_user_id(place_id, user_id)) || false
  end

  def self.cache_key_from_place_id_and_user_id(place_id, user_id)
    "favorited_#{place_id}_#{user_id}"
  end

  private

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
    
    until Rails.cache.fetch(favorite_cache_key).nil? || delete_attempts > 2
      Rails.cache.delete(favorite_cache_key)
    end

  end
end
