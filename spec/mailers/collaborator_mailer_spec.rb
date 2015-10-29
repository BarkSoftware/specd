RSpec.describe CollaboratorMailer do
  describe 'invite' do
    let(:collaborator) do
      project.collaborators.create!(
        email: junk,
        invite_token: junk,
      )
    end

    let(:project) do
      owner.projects.create! title: junk, github_repository: junk
    end

    let(:owner) do
      User.create!(
        full_name: junk,
        email: junk,
        uid: junk,
      )
    end

    let(:mail) { described_class.invite(collaborator) }

    it 'renders the subject' do
      expect(mail.subject).to eq("You've been invited to a new project")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([collaborator.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@specd.io'])
    end

    it 'includes project name' do
      expect(mail.body.encoded).to include(project.title)
    end

    it 'includes the owner full name' do
      expect(mail.body.encoded).to include(owner.full_name)
    end

    it 'includes confirmation link' do
      confirm_url = "/collaborators/confirm/#{collaborator.invite_token}"
      expect(mail.body.encoded).to include(confirm_url)
    end
  end
end
