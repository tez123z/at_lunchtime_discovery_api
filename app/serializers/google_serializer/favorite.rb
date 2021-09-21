module GoogleSerializer
  class Favorite
    def self.favorited?(place, user_id)
      FavoritePlace.exists?(place_id:place["place_id"],user_id:user_id)
    end
  end
end