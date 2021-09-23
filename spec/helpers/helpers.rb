# frozen_string_literal: true

module Helpers
  def json
    JSON.parse(response.body)
  end

  def token
    token_from_request = response.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token_from_request,
                               ENV["SECRET_KEY_BASE"], true)
    decoded_token.first['sub']
  end
end
