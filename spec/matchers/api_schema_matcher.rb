# frozen_string_literal: true

RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_directory = "#{Dir.pwd}/spec/matchers/api/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: false)
  end
end

RSpec::Matchers.define :include_google_place_type do |type|
  match do |response|
    results = JSON.parse(response.body)
    results['data'].all? { |result| result['types'].include?(type) }
  end
end
