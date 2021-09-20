module Helpers

  def json
    JSON.parse(response.body)
  end
  
  def token    
    token_from_request = response.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token_from_request, Rails.application.credentials[Rails.env.to_sym][:devise_jwt_secret_key], true)
    decoded_token.first['sub']
  end

end