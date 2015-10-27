require 'rails_helper'

RSpec.describe 'delete collaborator', type: :request do
  include_context 'github fixtures'

  let!(:delete_collaborator_stub) do
    stub_github_request(:delete, "repos/user/test-repo/collaborators/#{user.nickname}", {}.to_json)
  end

  let(:user) do
    User.create!(uid: junk, email: collaborator_email, nickname: junk)
  end

  let(:owner) { User.create!(uid: junk, email: junk, token: junk) }
  let(:project) { owner.projects.create!(github_repository: 'https://api.github.com/repos/user/test-repo') }
  junklet :collaborator_email
  let!(:collaborator) { project.collaborators.create!(email: collaborator_email) }

  it 'removes collaborator from project' do
    login_as owner
    delete api_collaborator_path(collaborator)
    expect(Collaborator.find_by_email(collaborator_email)).to be_nil
  end

  it 'only allows owner to delete' do
    login_as user
    delete api_collaborator_path(collaborator)
    expect(response.status).to eq(403)
  end

  context 'with collaborator confirmed' do
    before do
      collaborator.user = user
      collaborator.save!
    end

    it 'removes github collaborator too' do
      login_as owner
      delete api_collaborator_path(collaborator)
      expect(delete_collaborator_stub).to have_been_requested
    end
  end
end
