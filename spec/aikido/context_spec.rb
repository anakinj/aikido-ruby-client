# frozen_string_literal: true

RSpec.describe Aikido::Context do
  describe '#issues_for_code_repository' do
    context 'when issues exists', vcr: 'context_when_issues_exists' do
      it 'returns a list of issues' do
        context = described_class.new
        external_id = context.code_repositories.first['external_repo_id']
        list = context.issues_for_code_repository(external_repo_id: external_id)
        expect(list).to be_an(Array)
        expect(list.size).to be > 0
      end
    end
  end
end
