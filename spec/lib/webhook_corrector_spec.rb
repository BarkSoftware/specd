require 'rails_helper'

describe WebhookCorrector do
  subject { described_class.new(user, project).correct }
  junklet :token
  let(:repository) { 'api.github.com/test-repo' }
  let(:user) { double(token: junk) }
  let(:project) { double(id: 1, github_repository: repository) }

  context 'when the user has no access to hooks' do
    let!(:get_webhooks_stub) do
      stub_request(:get, %r{#{repository}/hooks}).to_return(
        status: 404,
        body: '[]',
      )
    end

    it 'does not error' do
      expect { subject }.to_not raise_error
    end
  end
end
