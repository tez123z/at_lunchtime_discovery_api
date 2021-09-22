module GoogleSerializer
  class Favorite
    def self.favorited?(place_id, user_id)
      FavoritePlace.exists?(place_id:place_id,user_id:user_id)
    end
  end
end