class WebhookCorrecter
  def initialize current_user, project
    @current_user = current_user
    @project = project
  end

  attr_reader :current_user, :project

  def correct
    InitProjectWebhook.new(current_user, project).init_webhook if webhook_missing?
  end

  def webhook_missing?
    existing_webhooks.none? do |hook|
      hook[:config][:url].andand.include? "#{Settings.host}/api/webhooks?project_id=#{project.id}"
    end
  end

  def existing_webhooks
    @existing_webhooks ||= api.get webhooks_url
  end

  def webhooks_url
    "#{project.github_repository}/hooks"
  end

  def api
    @api ||= GithubApi.new(current_user.token)
  end
end
