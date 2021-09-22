# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'oj'

class ApiService < ApplicationService
  attr_reader :response

  include HttpStatusCodes
  include ApiExceptions

  STAUTS_CODE_EXCEPTIONS = {
    HTTP_BAD_REQUEST_CODE => BadRequestError,
    HTTP_UNAUTHORIZED_CODE => UnauthorizedError,
    HTTP_FORBIDDEN_CODE => ForbiddenError,
    HTTP_NOT_FOUND_CODE => NotFoundError,
    HTTP_UNPROCESSABLE_ENTITY_CODE => UnprocessableEntityError,
    HTTP_TOO_MANY_REQUESTS => TooManyRequestsError,
    HTTP_SERVER_ERROR => ServerError,
    HTTP_GATEWAY_TIMEOUT => GatewayTimeoutError
  }.freeze

  private

  def request(http_method:, url:, payload: {})
    url = URI(url)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    if http_method == 'POST'
      request = Net::HTTP::Get.new(url)
    else
      request = Net::HTTP::Post.new(url)
      request.set_form_data(payload)
    end

    @response = https.request(request)

    parsed_response = Oj.load(response.body)

    return parsed_response if response_successful?

    raise error_class, "Code: #{response.code}, response: #{response.body}"
  end

  def error_class
    return STAUTS_CODE_EXCEPTIONS[response.code.to_i] if STAUTS_CODE_EXCEPTIONS[response.code.to_i]
    ApiError
  end

  def response_successful?
    response.code.to_i == HTTP_OK_CODE
  end

  def api_requests_quota_reached?
    response.body.match?(API_REQUSTS_QUOTA_REACHED_MESSAGE)
  end
end
