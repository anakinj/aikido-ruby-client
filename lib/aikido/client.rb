# frozen_string_literal: true

require 'httpx'

module Aikido
  # HTTP Client to interact with the Aikido API
  # Official documentation: https://apidocs.aikido.dev/
  class Client
    def initialize(client_id: nil, client_secret: nil)
      @client_id = client_id || ENV.fetch('AIKIDO_CLIENT_ID', nil)
      @client_secret = client_secret || ENV.fetch('AIKIDO_CLIENT_SECRET', nil)
    end

    def authorize
      http.plugin(:basic_auth).basic_auth(@client_id, @client_secret).post('/oauth/token',
                                                                           json: { grant_type: 'client_credentials' })
    end

    def issues(params: {})
      authed_http.get('/public/v1/issues/export', params: params).json
    end

    def issue(id)
      authed_http.get("/public/v1/issues/#{id.to_i}").json
    end

    def repositories
      # TODO: Paginated response
      authed_http.get('/public/v1/repositories/code', params: params).json
    end

    private

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
      @auth_token ||= authorize.json['access_token']
    end
  end
end
