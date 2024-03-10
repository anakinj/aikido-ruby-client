# frozen_string_literal: true

require 'httpx'

require_relative 'errors'
require_relative 'paginated_response'

module Aikido
  # HTTP Client to interact with the Aikido API
  # Official documentation: https://apidocs.aikido.dev/
  class Client
    def initialize(client_id: nil, client_secret: nil)
      @client_id     = client_id || ENV.fetch('AIKIDO_CLIENT_ID', nil)
      @client_secret = client_secret || ENV.fetch('AIKIDO_CLIENT_SECRET', nil)
    end

    def authorize
      handle_response!(http.plugin(:basic_auth)
                           .basic_auth(@client_id, @client_secret)
                           .post('/oauth/token', json: { grant_type: 'client_credentials' }))
    end

    def workspace
      get('/public/v1/workspace').json
    end

    def clouds
      PaginatedResponse.new do |page|
        get('/public/v1/clouds', params: { page: page }).json
      end
    end

    def issues(params: {})
      get('/public/v1/issues/export', params: params).json
    end

    def issue(id)
      get("/public/v1/issues/#{id.to_i}").json
    end

    def issue_groups
      PaginatedResponse.new do |page|
        get('/public/v1/open-issue-groups', params: { page: page }).json
      end
    end

    def issue_group(id)
      get("/public/v1/issues/groups/#{id.to_i}").json
    end

    def code_repositories
      PaginatedResponse.new do |page|
        get('/public/v1/repositories/code', params: { page: page }).json
      end
    end

    def code_repository_sbom(id, format: 'csv')
      get("repositories/code/#{id.to_i}/licenses/export", params: { format: format }).body
    end

    private

    def get(path, params: {})
      handle_response!(authed_http.get(path, params: params))
    end

    def authed_http
      http.plugin(:auth).bearer_auth(auth_token)
    end

    def http
      @http ||= HTTPX.with(origin: 'https://app.aikido.dev',
                           base_path: '/api',
                           headers: { 'Content-Type' => 'application/json',
                                      'Accept' => 'application/json',
                                      'User-Agent' => "Aikido Ruby Client #{Aikido::VERSION}" })
    end

    def auth_token
      # TODO: Handle token expiration
      @auth_token ||= authorize.json['access_token']
    end

    def handle_response!(response)
      case response.status
      when 200..299
        response
      else
        raise_response_error!(response)
      end
    end

    def raise_response_error!(response)
      case response.status
      when 401
        raise Errors::UnauthorizedError, response
      else
        raise Errors::ApiError, response
      end
    end
  end
end
