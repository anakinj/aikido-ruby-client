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

  describe '#issue' do
    context 'when fetching one issue', vcr: 'issue' do
      it 'returns one issue' do
        client = Aikido::Client.new
        expect(client.issue(client.issues.first['id'])).to be_a(Hash)
      end
    end

    context 'when filter parameters are given', vcr: 'issue_filter' do
      it 'returns a list of issues' do
        client = Aikido::Client.new
        expect(client.issues(filter_status: 'ignored')).to be_an(Array)
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

  describe '#code_repository_sbom' do
    context 'when exporting a code repository SBOM', vcr: 'code_repository_sbom_csv' do
      it 'returns a CSV file' do
        pending 'No good test data for this one'
        client = Aikido::Client.new
        repos = client.code_repositories
        expect(client.code_repository_sbom(repos.first['id'])).to be_a(String)
      end
    end
  end

  describe '#teams' do
    context 'when listing teams', vcr: 'teams' do
      it 'returns a list of teams' do
        client = Aikido::Client.new
        expect(client.teams).to be_an(Aikido::PaginatedResponse)
      end
    end
  end

  describe '#create_team' do
    context 'when creating a team', vcr: 'create_team' do
      it 'returns the id of the team' do
        client = Aikido::Client.new
        expect(client.create_team(name: 'Team name')['id']).to be_an(Integer)
      end
    end

    context 'when name is not given', vcr: 'create_team_no_name' do
      it 'raises an error' do
        client = Aikido::Client.new
        expect { client.create_team(name: nil) }.to raise_error(Aikido::Errors::BadRequestError) do |error|
          expect(error.message).to eq('API Error: 400 - Field is not set: name')
        end
      end
    end
  end

  describe '#containers' do
    context 'when listing containers', vcr: 'containers' do
      it 'returns a list of containers' do
        client = Aikido::Client.new
        expect(client.containers).to be_an(Array)
      end
    end
  end
end
