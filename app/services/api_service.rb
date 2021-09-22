require "uri"
require "net/http"
require "oj"

class ApiService < ApplicationService
      
      include HttpStatusCodes
      include ApiExceptions

      private

      def response
        @response
      end
      
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
        case response.code.to_i
        when HTTP_BAD_REQUEST_CODE
          BadRequestError
        when HTTP_UNAUTHORIZED_CODE
          UnauthorizedError
        when HTTP_FORBIDDEN_CODE
          return ApiRequestsQuotaReachedError if api_requests_quota_reached?
          ForbiddenError
        when HTTP_NOT_FOUND_CODE
          NotFoundErrorv
        when HTTP_UNPROCESSABLE_ENTITY_CODE
          UnprocessableEntityError
        when HTTP_TOO_MANY_REQUESTS
          TooManyRequestsError
        when HTTP_SERVER_ERROR
          ServerError
        when HTTP_GATEWAY_TIMEOUT
          GatewayTimeoutError
        else
          ApiError
        end
      end
      
      def response_successful?
        response.code.to_i == HTTP_OK_CODE
      end

      def api_requests_quota_reached?
        response.body.match?(API_REQUSTS_QUOTA_REACHED_MESSAGE)
      end
      
end