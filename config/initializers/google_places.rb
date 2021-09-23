# frozen_string_literal: true
require './lib/google_maps'

GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']

Google::Maps.configure do |config|
  config.api_key = ENV['GOOGLE_API_KEY'] || Rails.application.credentials[Rails.env.to_sym][:google_api_key]
end

