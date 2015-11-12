class WebhookCorrector
  def initialize current_user, project
    @current_user = current_user
    @project = project
  end

  attr_reader :current_user, :project

  def correct
    if webhooks_response.success?
      InitProjectWebhook.new(current_user, project).init_webhook if webhook_missing?
    end
  end

  def webhook_missing?
    existing_webhooks.none? do |hook|
      hook[:config][:url].andand.include? "#{Settings.host}/api/webhooks?project_id=#{project.id}"
    end
  end

  def existing_webhooks
    JSON.parse(webhooks_response.body, symbolize_names: true)
  end

  def webhooks_response
    @webhooks_response ||= api.get_response webhooks_url
  end

  def webhooks_url
    "#{project.github_repository}/hooks"
  end

  def api
    @api ||= GithubApi.new(current_user.token)
  end
end
