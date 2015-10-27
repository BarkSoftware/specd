class InitProjectWebhook
  def initialize current_user, project
    @current_user = current_user
    @project = project
  end

  attr_reader :project, :current_user

  def init_webhook
    project.update_attributes(webhook_secret: secret)
    create_webhook
  end

  def create_webhook
    GithubApi.new(current_user.token).post(
      project.github_repository + '/hooks',
      {
        name: 'web',
        events: ['*'],
        active: true,
        config: {
          url: "#{Settings.host}/api/webhooks?project_id=#{project.id}",
          content_type: 'json',
          secret: secret,
          insecure_ssl: 1,
        }
      }
    )
  end

  def secret
    @secret ||= SecureRandom.uuid
  end
end
