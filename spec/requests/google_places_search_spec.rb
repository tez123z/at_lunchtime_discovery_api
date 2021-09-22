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

  let(:invalid_location_params) do
    {
      query: 'Burgers',
      location: '34.885253490'
    }
  end

  let(:invalid_language_params) do
    {
      query: 'Burgers',
      language: 'xcrp',
      location: '34.885253490,-82.4170214515'
    }
  end

  let(:invalid_maxprice_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515',
      maxprice: 5
    }
  end

  let(:invalid_minprice_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515',
      minprice: 5
    }
  end

  let(:invalid_opennow_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515',
      opennow: 'sure'
    }
  end

  let(:invalid_radius_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515',
      radius: 500_000
    }
  end

  let(:invalid_type_params) do
    {
      query: 'Burgers',
      location: '34.885253490,-82.4170214515',
      type: 'haberdashery'
    }
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
      expect(response.status).to eq 400
    end
  end

  context 'when search params have bad location parameter' do
    before { post url, params: invalid_location_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params bad language parameter' do
    before { post url, params: invalid_language_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params bad maxprice parameter' do
    before { post url, params: invalid_maxprice_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params bad minprice parameter' do
    before { post url, params: invalid_minprice_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params bad opennow parameter' do
    before { post url, params: invalid_opennow_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params bad radius parameter' do
    before { post url, params: invalid_radius_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end

  context 'when search params type parameter' do
    before { post url, params: invalid_type_params, headers: valid_headers, as: :json }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end
end
