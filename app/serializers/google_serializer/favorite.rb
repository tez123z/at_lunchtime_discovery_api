# frozen_string_literal: true

module GoogleSerializer
  class Favorite
    def self.favorited?(place_id, user_id)
      if Rails.application.config.action_controller.perform_caching
        FavoritePlace.cache_from_place_id_and_user_id(
          place_id, user_id
        )
      else
        FavoritePlace.exists?(place_id: place_id, user_id: user_id)
      end
    end
  end
end
