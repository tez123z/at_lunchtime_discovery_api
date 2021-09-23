# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /search', type: :request do
  let(:user) { Fabricate(:user) }
  let(:valid_headers) do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  let(:url) { '/search' }
  let(:valid_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515'
    }
  end

  let(:valid_params_with_pagetoken) do
    result = GoogleServices::Place::TextSearch.call({query: 'Burgers',location: '34.885253490,-82.4170214515'})
    results,next_page_token = result.payload
    new_params = valid_params.merge({pagetoken:next_page_token})
    new_params
  end

  context 'without active session' do
    before do
      post url, params: valid_params
    end
    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end

  context 'with active session when params are correct' do
    before do
      post url, params: valid_params, headers: valid_headers, as: :json
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'set to type restaurant by default' do
      expect(response).to include_google_place_type('restaurant')
    end

    it 'matches search results json schema' do
      expect(response).to match_response_schema('google_places_search_results')
    end
  end

  context 'when search params missing query parameter' do
    before { post url, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 422
    end
  end

  context 'when search params with ratings sorted' do
    before do
      post url, params: valid_params.merge({sort_by_ratings:"asc"}), headers: valid_headers, as: :json
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'set to type restaurant by default' do
      expect(response).to include_google_place_type('restaurant')
    end

    it 'matches search results json schema' do
      expect(response).to match_response_schema('google_places_search_results')
    end

    it 'matches search results json schema' do
      response_body = JSON.parse(response.body)
      expect(response_body['data'][0]['rating']).to be <= response_body['data'][1]['rating']
    end
  end


end
