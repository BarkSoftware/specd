class InitProjectColumns

  def initialize current_user, project
    @project = project
    @current_user = current_user
  end

  attr_reader :project, :current_user
  delegate :columns, to: :project

  def init_columns
    Settings.column_types.each_with_index do |column_type, i|
      create_column(column_type, i).tap do |column|
        init_open_issues column if column.issues_start_here?
        init_closed_issues column if column.closed?
      end
    end
  end

  private

  def init_closed_issues column
    github_issues.select { |i| i[:state] == 'closed'}.each do |issue|
      column.issues.create!(
        project_id: project.id,
        number: issue[:number],
      )
    end
  end

  def init_open_issues column
    open_issues.each do |issue|
      issue_type = IssueTypes::SPEC
      issue_type = IssueTypes::BUG if issue[:labels].any? { |label| label[:name].downcase == 'bug' }
      issue_type = IssueTypes::QUESTION if issue[:labels].any? { |label| label[:name].downcase == 'question' }
      column.issues.create!(
        project_id: project.id,
        number: issue[:number],
        issue_type: issue_type,
      )
    end
  end

  def create_column column_type, ordinal
    columns.create! column_type.merge('ordinal' => ordinal)
  end

  def github_issues
    @github_issues ||= GithubApi.new(current_user.token)
      .get(project.issues_url)
  end

  def closed_issues
    issues_by_state 'closed'
  end

  def open_issues
    issues_by_state 'open'
  end

  def issues_by_state state
    github_issues.select { |i| i[:state] == state }
  end

end
