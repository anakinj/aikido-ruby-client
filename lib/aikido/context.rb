# frozen_string_literal: true

module Aikido
  # Represents a context for interacting with the Aikido API
  # Context will store data in memory for further processing
  class Context
    def initialize(client: nil)
      @client = client || Aikido::Client.new
    end

    def issues_for_code_repository(external_repo_id:)
      repo = code_repositories.find { |r| r['external_repo_id'] == external_repo_id }
      return [] unless repo

      issues.select do |issue|
        issue['code_repo_id'] == repo['id']
      end
    end

    def code_repositories
      @code_repositories ||= @client.code_repositories
    end

    def issues
      @issues ||= @client.issues
    end
  end
end
