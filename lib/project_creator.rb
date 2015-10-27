class ProjectCreator
  def initialize current_user
    @current_user = current_user
  end

  attr_reader :current_user

  def create project_params = {}
    current_user.projects.create!(project_params).tap do |project|
      InitProjectColumns.new(current_user, project).init_columns
      InitProjectWebhook.new(current_user, project).init_webhook
    end
  end
end
