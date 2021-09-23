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

        begin
          
          results = Rails.cache.fetch("google_places_search_#{@search_params.to_query}", expires_in: 24.hours) do
            Google::Maps::Place.text_search(@search_params)
          end
          
          sorted_results = sort_by_ratings ? results['results'].sort{ |a, b|  
            sort_by_ratings.downcase == 'asc' ? a['rating'] <=> b['rating'] : b['rating'] <=> a['rating']  
          } : results['results']

          OpenStruct.new({ success?: true, payload: [sorted_results, results['next_page_token']] })

        rescue => e
          
          OpenStruct.new({ success?: false, errors: { google_api: [e] } })

        end

      end
    end
  end
end
