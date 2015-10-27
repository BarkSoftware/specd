require 'rails_helper'

RSpec.describe 'confirm invitation', type: :request do
  include_examples 'existing project'

  junklet :invite_token

  let(:collaborator) { junk_user }

  let!(:put_collaborator_stub) do
    %r{api.github.com/#{path}}
    stub_request(:put, github_repo_pattern("collaborators/#{collaborator.nickname}")).to_return(
      status: 201,
      body: {}.to_json,
    )
  end

  before do
    project.collaborators.create!(
      email: collaborator.email,
      invite_token: invite_token,
    )
    login_as collaborator
    post api_confirm_collaborator_url, invite_token: invite_token
  end

  it 'confirms the collaborator and assigns user' do
    collaboration = Collaborator.find_by!(invite_token: invite_token)
    expect(collaboration.user_id).to eq(collaborator.id)
    expect(collaboration.confirmed).to be_truthy
  end

  it 'adds collaborator as a github collaborator' do
    expect(put_collaborator_stub).to have_been_requested
  end

  context 'when the repo is non-organization' do
    let(:get_repository_json) do
      super().except(:organization)
    end

    it 'omits the permission parameter' do
      expect(put_collaborator_stub.with do |req|
        expect(req.body).to_not include('permission')
        true
      end).to have_been_requested
    end
  end

  context 'when the repo is organization type' do
    let(:get_repository_json) do
      super().merge(organization: {})
    end

    it 'includes the permission parameter' do
      expect(put_collaborator_stub.with do |req|
        expect(req.body).to include('permission')
        true
      end).to have_been_requested
    end
  end
end
