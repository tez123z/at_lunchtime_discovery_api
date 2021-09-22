require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do


  let(:url) { '/signup' }
  let(:params) do
    {
      user: {
        email: "tester@email.com",
        password: "testing123"
      }
    }
  end

  context 'when params are correct' do
    
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      expect(token).to be_present
    end

    it 'matches user json schema' do
      expect(response).to match_response_schema("user")
    end
    
  end

  context 'when sign params are incorrect' do
    before { post url }
    
    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end
  
end

RSpec.describe 'DELETE /signup', type: :request do
  
  let(:url) { '/signup' }

  let(:user) { Fabricate(:user) }
  let(:valid_headers) {
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  }

  it 'returns 200, no content' do
    delete url, headers: valid_headers
    expect(response).to have_http_status(200)
  end
end