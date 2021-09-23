# frozen_string_literal: true

module GoogleServices
  module Place
    class TextSearch < ApplicationService
      attr_reader :search_params, :sort_by_ratings

      DEFAULT_SEARCH_PARAMS = { type: 'restaurant' }.freeze

      def initialize(search_params = {})
        @sort_by_ratings = search_params[:sort_by_ratings]
        @search_params = DEFAULT_SEARCH_PARAMS.merge(search_params)
      end

      def call
        results = Rails.cache.fetch("google_places_search_#{@search_params.to_query}", expires_in: 24.hours) do
          Google::Maps::Place.text_search(@search_params)
        end

        OpenStruct.new({ success?: true, payload: [results['results'], results['next_page_token']] })
      rescue StandardError => e
        OpenStruct.new({ success?: false, errors: { google_api: [e] } })
      end
    end
  end
end
