require 'google_serializer/photos'
module GoogleSerializer
  class Place
    def initialize(resource, options = {})
        @resource = resource
        @include_photo_urls = options[:include_photo_urls] || false
        @include_favorites = options[:include_favorites] || false
        @user = options[:current_user] || nil
    end

    def to_hash
      
      if @resource.kind_of?(Array)
        return hash_for_places
      end

      has_for_one_place

    end

    def hash_for_places
      @resource.map do |record| 
        hash_for_one_place(record) 
      end
    end

    def hash_for_one_place(record = nil)
      serializable_hash = record || @resource
      GoogleSerializer::Photos.add_urls(serializable_hash) if @include_photo_urls
      GoogleSerializer::Favorite.favorited?(serializable_hash, @user) if @include_favorites && @user
      serializable_hash
    end

  end
end
