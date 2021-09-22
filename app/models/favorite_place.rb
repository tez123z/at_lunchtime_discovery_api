class FavoritePlace < ApplicationRecord
  
  belongs_to :user
  
  validates_presence_of :place_id
  validates_uniqueness_of :place_id, scope: :user_id

  after_create :add_cache
  after_destroy :remove_cache
  
  def self.cache_from_place_id_and_user_id(place_id,user_id)
    Rails.cache.fetch(FavoritePlace.cache_key_from_place_id_and_user_id(place_id,user_id)) || false
  end

  def self.cache_key_from_place_id_and_user_id(place_id,user_id)
    "favorited_#{place_id}_#{user_id}"
  end

  private

    def add_cache
      Rails.cache.fetch(FavoritePlace.cache_key_from_place_id_and_user_id(place_id,user_id)) { 
        true 
      }
    end

    def remove_cache
      Rails.cache.delete(FavoritePlace.cache_key_from_place_id_and_user_id(place_id,user_id))
    end

end
