# frozen_string_literal: true

module GoogleSerializer
  class Place
    attr_reader :resource, :include_photo_urls, :include_favorites, :user_id

    def initialize(resource, options = {})
      @resource = resource
      @include_photo_urls = options[:include_photo_urls] || false
      @include_favorites = options[:include_favorites] || false
      @user_id = options[:user_id] || nil
    end

    def to_hash
      return hash_for_places if resource.is_a?(Array)

      hash_for_one_place
    end

    def hash_for_places
      resource.map do |record|
        hash_for_one_place(record)
      end
    end

    def hash_for_one_place(record = nil)
      serializable_hash = record || resource
      raise MandatoryField, 'place_id is a mandatory field for place object' unless serializable_hash.key?('place_id')

      GoogleSerializer::Photos.add_urls(serializable_hash) if include_photo_urls
      if include_favorites && user_id
        serializable_hash['favorited'] =
          GoogleSerializer::Favorite.favorited?(serializable_hash['place_id'], @user_id)
      end
      serializable_hash
    end
  end
end
