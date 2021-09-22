module ApiExceptions
  class MissingAPICredentials < StandardError; end
  class APIExceptionError < StandardError; end
  class BadRequestError < APIExceptionError 
    def message
      "Bad Request"
    end
  end
  class UnauthorizedError < APIExceptionError 
    def message
      "Unauthorized"
    end
  end
  class ForbiddenError < APIExceptionError 
    def message
      "Forbidden"
    end
  end

  class ApiRequestsQuotaReachedError < APIExceptionError 
    def message
      "Request Limit Reached"
    end
  end

  class NotFoundError < APIExceptionError 
    def message
      "Not Found"
    end
  end

  class UnprocessableEntityError < APIExceptionError 
    def message
      "Unprocessible Entity"
    end
  end

  class TooManyRequestsError < APIExceptionError 
    def message
      "Too Many Requests"
    end
  end

  class ServerError < APIExceptionError 
    def message
      "Server Error"
    end
  end

  class GatewayTimeoutError < APIExceptionError 
    def message
      "Gateway Timeout"
    end
  end

  class ApiError < APIExceptionError 
    def message
      "API Error"
    end
  end
end