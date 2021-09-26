# frozen_string_literal: true

module GoogleSerializer
  class Place
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations

    attr_accessor :place_id, :name, :geometry, :types, :photos, :rating, :user_ratings_total, :opening_hours, :price_level, :user_id

    validates_presence_of :place_id
    validates_presence_of :name
    validates_presence_of :geometry

    def initialize(attrs)
      attrs.each do |attr, value|
        if attr == "photos"
          self.photos = attrs[attr].map do |p|
            Photo.new(p)
          end
        else
          send("#{attr}=", value) if respond_to?("#{attr}=")
        end
      end
    end

    def attributes
      [:place_id, :name, :geometry, :types, :rating, :user_ratings_total, :opening_hours, :price_level].inject({}) do |hash, attr|
        hash[attr] = send(attr)
        hash
      end
    end

    def current_user
      return unless user_id
      @current_user ||= User.find(user_id)
    end

    def favorited
      return false unless current_user
      current_user.favorite_places.exists?(place_id:place_id) || false
    end

  end
end
