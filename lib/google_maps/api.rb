# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'oj'

module Google
  module Maps
    class InvalidRequestException < StandardError; end

    class InvalidResponseException < StandardError; end

    class InvalidPremierConfigurationException < StandardError; end

    class ZeroResultsException < InvalidResponseException; end

    class API
      STATUS_OK = 'OK'
      STATUS_ZERO_RESULTS = 'ZERO_RESULTS'

      class << self
        def query(service, args = {})
          handle_required_keys(service, args)
          url = url(service, args)
          response(url)
        end

        def head(service, args = {})
          handle_required_keys(service, args)
          url = url(service, args)
          head_response(url)
        end

        def url(service, args = {})
          url_with_api_key(service, args)
        end

        private

        def handle_required_keys(service, args)
          required_keys = Google::Maps.required_keys[service]

          if required_keys
            missing_keys = required_keys - args.symbolize_keys.filter { |_k, v| v.present? }.keys
            if missing_keys.length.positive?
              raise InvalidRequestException,
                    "Missing required parameters `#{missing_keys.join(',')}`"
            end
          end
        end

        def response(url)
          retries = 0
          begin
            uri = URI(url)
            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true
            request = Net::HTTP::Get.new(uri)
            response = https.request(request)
            result = Oj.load(response.body)
          rescue StandardError => e
            if Google::Maps.exponential_backoff && retries < Google::Maps.exponential_backoff_max_retries
              retries += 1
              sleep 2**retries
              retry
            end
            raise InvalidResponseException, "Google API Unkown Error : #{e.message}"
          end
          handle_result_status(result['status'])
          result
        end

        def head_response(url)
          retries = 0
          begin
            uri = URI(url)
            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true
            request = Net::HTTP::Head.new(uri)
            response = https.request(request)
            result = response['location']
          rescue StandardError => e
            raise InvalidResponseException, "Google API Unkown Error : #{e.message}"
          end
          result
        end

        def handle_result_status(status)
          raise ZeroResultsException, "Google did not return any results: #{status}" if status == STATUS_ZERO_RESULTS
          raise InvalidResponseException, "Google returned an error status: #{status}" if status != STATUS_OK
        end

        def url_with_api_key(service, args = {})
          base_url(service, args.merge(key: Google::Maps.api_key))
        end

        def base_url(service, args = {})
          url = URI.parse("#{Google::Maps.end_point}#{Google::Maps.send(service)}#{Google::Maps.excludes_format.include?(service) ? '' : "/#{Google::Maps.format}"}#{query_string(args)}")
          url.to_s
        end

        def query_string(args = {})
          "?#{URI.encode_www_form(args)}" unless args.empty?
        end
      end
    end
  end
end
