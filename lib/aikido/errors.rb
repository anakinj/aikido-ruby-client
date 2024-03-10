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
        if @response.json['error_description']
          "#{super} - #{@response.json['error_description']}"
        else
          super
        end
      end
    end
    UnauthorizedError = Class.new(ApiError)
    NotFoundError = Class.new(ApiError)
  end
end
