module GoogleSerializer
  class Places
    attr_accessor :results
    def initialize(places, user_id = nil)
      @results = places.map{|place|
        p = Place.new(place.merge({user_id:user_id}))
        p.valid? ? p.serializable_hash(include: { photos: { methods: :photo_url }},methods: :favorited) : nil
      }.compact
    end
  end
end