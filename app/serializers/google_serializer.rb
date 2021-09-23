# frozen_string_literal: true

module GoogleSerializer
  MandatoryField = Class.new(StandardError)
  MalformedField = Class.new(StandardError)
  
  def follow(url, redirects = 5, &block)
    raise RuntimeError, "Too many redirects" if redirects == 0
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      yield(url)
      request = Net::HTTP::Head.new(uri.request_uri)
      response = http.request(request)
      case response
      when Net::HTTPRedirection
        follow(response['location'], redirects - 1, &block)
      end
    end
  end

end
