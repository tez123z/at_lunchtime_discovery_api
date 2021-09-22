# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def respond_with(resource, _opts = {})
    render_resource(resource)
  end
end
