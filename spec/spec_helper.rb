# frozen_string_literal: true

require 'vcr'
require 'webmock/rspec'
require 'httpx/adapters/webmock'

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'aikido-ruby-client'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<AUTHORIZATION_HEADER>') do |interaction|
    interaction.request.headers['Authorization'].first
  end

  config.filter_sensitive_data('<JWT_TOKEN>') do |interaction|
    interaction.response.body.match(/eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*/)
  end
end
