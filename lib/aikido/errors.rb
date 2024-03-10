# frozen_string_literal: true

module Aikido
  module Errors
    AikidoError = Class.new(StandardError)

    # Represents an error that occurred while making an API request.
    class ApiError < AikidoError
      def initialize(response)
        @response = response
        super("API Error: #{response.status}")
      end

      def message
        json = @response.json
        if json.key?('error_description')
          "#{super} - #{json['error_description']}"
        elsif json.key?('reason_phrase')
          "#{super} - #{json['reason_phrase']}"
        else
          super
        end
      end
    end

    BadRequestError   = Class.new(ApiError)
    UnauthorizedError = Class.new(ApiError)
    NotFoundError     = Class.new(ApiError)
  end
end
