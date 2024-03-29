# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  respond_to :json

  rescue_from Exception do |exception|
    render json: { errors: [exception] }, status: :internal_server_error
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: resource.errors, status: :bad_request
  end
end
