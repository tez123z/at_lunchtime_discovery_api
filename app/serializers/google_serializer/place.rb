# frozen_string_literal: true

module GoogleSerializer
  class Place
    include ActiveModel::Serializers::JSON
    
    attr_accessor :place_id, :name, :geometry, :photos, :rating, :user_ratings_total, :opening_hours, :price_level, :user_id

    def initialize(attrs)
      attrs.each do |attr, value|
        if attr.to_s == "photos"
          self.photos = attrs[attr].map do |p|
            Photo.new(p)
          end
        else
          send("#{attr}=", value) if respond_to?("#{attr}=")
        end
      end
    end

    def attributes
      [:place_id, :name, :geometry, :rating, :user_ratings_total, :opening_hours, :price_level].inject({}) do |hash, attr|
        hash[attr] = send(attr)
        hash
      end
    end

    def current_user
      User.find(user_id)
    end

    def favorited
      current_user.favorite_places.exists?(place_id:place_id) || false
    end

    # def validate_options
    #   raise MalformedField, "favorite_place_ids must be array of strings" unless @favorite_place_ids.is_a?(Array)
    #   raise MalformedField, "resource must be array or hash" unless @resource.class.in?([Array, Hash])

    #   unless @sort_by_ratings.nil? || @sort_by_ratings.downcase.in?(SORT_BY_RATINGS_VALUES)
    #     raise MalformedField,
    #           "sort_by_ratings included in #{SORT_BY_RATINGS_VALUES}"
    #   end
    # end

  end
end
