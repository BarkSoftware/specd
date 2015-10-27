require 'rails_helper'

describe 'email invite', type: :request do
  junklet :collaborator_email, :user_email, :non_owner_email
  let(:user) { User.create!(uid: junk, email: user_email) }
  let(:project) { user.projects.create!(github_repository: junk) }
  let(:non_owner) { User.create!(uid: junk, email: non_owner_email) }

  shared_examples 'the user can invite collaborators' do
    it 'creates an un-approved invite' do
      send_invite
      Collaborator.find_by!(email: collaborator_email).tap do |c|
        expect(c.project_id).to eq(project.id)
        expect(c.email).to eq(collaborator_email)
        expect(c.invite_token).to be_present
        expect(c.confirmed).to be_falsy
        expect(c.user_id).to be_nil
        expect(c.type).to eq('Sponsor')
      end
    end
  end

  before do
    login_as user
  end

  def send_invite
    post(
      api_collaborators_url,
      project_id: project.id,
      email: collaborator_email,
      type: 'Sponsor',
    )
  end

  it_behaves_like 'the user can invite collaborators'

  it 'sends an email to the recipient' do
    expect { send_invite }
      .to change { ActionMailer::Base.deliveries.count }
      .by(1)
  end

  it 'denies non-collaborators' do
    login_as non_owner
    expect{ send_invite }.to raise_error
  end

  context 'logged in as a collaborator' do
    before do
      project.collaborators.create!(
        invite_token: SecureRandom.uuid,
        user_id: non_owner.id,
        email: non_owner.email,
        type: 'developer',
        confirmed: true,
      )
      login_as non_owner
    end

    it_behaves_like 'the user can invite collaborators'
  end
end
