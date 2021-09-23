# frozen_string_literal: true

module GoogleSerializer
  class Place
    attr_reader :resource, :include_photo_urls, :favorite_place_ids, :sort_by_ratings

    SORT_BY_RATINGS_VALUES = %w[asc desc].freeze

    def initialize(resource, options = {})
      @resource = resource
      @include_photo_urls = options[:include_photo_urls] || false
      @favorite_place_ids = options[:favorite_place_ids] || []
      @sort_by_ratings = options[:sort_by_ratings] || nil

      validate_options
    end

    def to_hash
      return hash_for_places if resource.is_a?(Array)

      hash_for_one_place
    end

    private

    def validate_options
      raise MalformedField, "favorite_place_ids must be array of strings" unless @favorite_place_ids.is_a?(Array)
      raise MalformedField, "resource must be array or hash" unless @resource.class.in?([Array, Hash])

      unless @sort_by_ratings.nil? || @sort_by_ratings.downcase.in?(SORT_BY_RATINGS_VALUES)
        raise MalformedField,
              "sort_by_ratings included in #{SORT_BY_RATINGS_VALUES}"
      end
    end

    def hash_for_places
      results = resource.map do |record|
        hash_for_one_place(record)
      end

      sort_results(results)
    end

    def hash_for_one_place(record = nil)
      serializable_hash = record || resource

      raise MandatoryField, 'place_id is a mandatory field for place object' unless serializable_hash.key?('place_id')

      GoogleSerializer::Photos.add_urls(serializable_hash) if include_photo_urls
      serializable_hash['favorited'] =
        favorite_place_ids.length.positive? ? serializable_hash['place_id'].in?(favorite_place_ids) : false

      serializable_hash
    end

    def sort_results(results)
      if sort_by_ratings
        results.sort do |a, b|
          if sort_by_ratings.casecmp('asc').zero?
            a['rating'] <=> b['rating']
          else
            b['rating'] <=> a['rating']
          end
        end
      else
        results
      end
    end
  end
end
