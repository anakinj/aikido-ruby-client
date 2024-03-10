# frozen_string_literal: true

RSpec.describe Aikido::Client do
  context 'when invalid credentials', vcr: 'invalid_credentials' do
    it 'raises an error' do
      client = Aikido::Client.new(client_id: 'invalid', client_secret: 'invalid')
      expect { client.authorize }.to raise_error(Aikido::Errors::UnauthorizedError) do |error|
        expect(error.message).to eq('API Error: 401 - The provided credentials are invalid')
      end
    end
  end

  describe '#issues' do
    context 'when listing issues', vcr: 'issues' do
      it 'returns a list of issues' do
        client = Aikido::Client.new
        expect(client.issues).to be_an(Array)
      end
    end
  end

  describe '#code_repositories' do
    context 'when listing code repositories', vcr: 'code_repositories' do
      it 'returns a list of code repositories' do
        client = Aikido::Client.new
        expect(client.code_repositories).to be_an(Aikido::PaginatedResponse)
      end
    end
  end

  describe '#workspaces' do
    context 'when listing workspaces', vcr: 'workspaces' do
      it 'returns a list of workspaces' do
        client = Aikido::Client.new
        expect(client.workspace).to be_an(Hash)
      end
    end
  end

  describe '#clouds' do
    context 'when listing clouds', vcr: 'clouds' do
      it 'returns a list of clouds' do
        client = Aikido::Client.new
        expect(client.clouds).to be_an(Aikido::PaginatedResponse)
      end
    end
  end

  describe '#issue_groups' do
    context 'when listing issue groups', vcr: 'issue_groups' do
      it 'returns a list of issue groups' do
        client = Aikido::Client.new
        expect(client.issue_groups).to be_an(Aikido::PaginatedResponse)
      end
    end
  end
end
