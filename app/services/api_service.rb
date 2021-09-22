require "uri"
require "net/http"
class ApiService < ApplicationService

      APIError = Class.new(StandardError)
      BadRequestError = Class.new(APIError)
      UnauthorizedError = Class.new(APIError)
      ForbiddenError = Class.new(APIError)
      ApiRequestsQuotaReachedError = Class.new(APIError)
      NotFoundError = Class.new(APIError)
      UnprocessableEntityError = Class.new(APIError)
      
      HTTP_OK_CODE = 200

      HTTP_BAD_REQUEST_CODE = 400
      HTTP_UNAUTHORIZED_CODE = 401
      HTTP_FORBIDDEN_CODE = 403
      HTTP_NOT_FOUND_CODE = 404
      HTTP_UNPROCESSABLE_ENTITY_CODE = 429


      private
      
      def request(http_method:, endpoint:, params: {})
        response = client.public_send(http_method, endpoint, params)
        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?

        raise error_class, "Code: #{response.status}, response: #{response.body}"
      end
      
      def error_class
        case response.status
        when HTTP_BAD_REQUEST_CODE
          BadRequestError
        when HTTP_UNAUTHORIZED_CODE
          UnauthorizedError
        when HTTP_FORBIDDEN_CODE
          return ApiRequestsQuotaReachedError if api_requests_quota_reached?
          ForbiddenError
        when HTTP_NOT_FOUND_CODE
          NotFoundError
        when HTTP_UNPROCESSABLE_ENTITY_CODE
          UnprocessableEntityError
        else
          ApiError
        end
      end
      
      def response_successful?
        response.status == HTTP_OK_CODE
      end

      def api_requests_quota_reached?
        response.body.match?(API_REQUSTS_QUOTA_REACHED_MESSAGE)
      end
      
end