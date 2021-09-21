module GoogleSerializer
  class Favorite
    def self.favorited?(place, user)
      FavoritePlace.exists?(place_id:place["place_id"],user_id:user.id)
    end
  end
end