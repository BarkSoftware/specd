require 'rails_helper'

describe Project do
  let(:github_repo) {'https://api.github.com/test/repo' }
  subject { described_class.new(github_repository: github_repo) }

  context 'without github_repository' do
    let(:github_repo) { nil }
    it 'is invalid' do
      expect(subject.valid?).to be_falsey
    end
  end

  describe '#github_data' do
    subject { super().github_data junk_user }
    let!(:github_repo_stub) { stub_request(:get, %r{.*/test/repo}).to_return(status: 200, body: {}.to_json) }

    it 'gets the repository data from github' do
      subject
      expect(github_repo_stub).to have_been_requested
    end
  end
end
