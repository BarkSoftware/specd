class IssueSerializer < ActiveModel::Serializer
  attributes :id,
             :issue_type,
             :number,
             :project_id,
             :estimate,
             :estimate_type,
             :github

  def estimate_type
    project.estimate_type
  end

  def project
    object.column.project
  end

  def project_id
    project.id
  end

  def github_issue
    @github_issue ||= GithubApi.new(scope.token).get(object.github_url)
  end

  def github
    github_issue
  end

end
