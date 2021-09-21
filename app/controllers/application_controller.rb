class ApplicationController < ActionController::API
  respond_to :json

  rescue_from RailsParam::Param::InvalidParameterError do |exception|
    render json: {errors:[exception]}, status: :bad_request
  end

  # rescue_from User::NotAuthorized do |exception|
  #   render json: {errors:[exception]}, status: :unauthorized
  # end

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end
end
