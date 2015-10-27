class CollaboratorMailer < ActionMailer::Base
  default from: "no-reply@specd.io"

  def invite collaborator
    @collaborator = collaborator
    @project = collaborator.project
    @owner = @project.user
    @confirmation_url = confirmation_url
    mail to: collaborator.email, subject: "You've been invited to a new project"
  end

  private

  attr_accessor :collaborator

  def confirmation_url
    "https://specd.io/client/collaborators/confirm/#{collaborator.invite_token}"
  end
end
