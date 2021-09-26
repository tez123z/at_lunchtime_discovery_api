module GoogleSerializer
  class Places
    attr_accessor :user_id, :results
    def initialize(places, user_id)
      @user_id = user_id
      @results = places.map do |place|
        Place.new(place.merge({user_id:user_id})).serializable_hash(include: { photos: { methods: :photo_url }},methods: :favorited)
      end
    end
  end
end