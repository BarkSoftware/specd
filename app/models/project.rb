class Project < ActiveRecord::Base
  has_many :collaborators
  has_many :columns
  has_many :issues, through: :columns
  belongs_to :user

  validates_presence_of :github_repository

  def is_organization_repo?
    github_data(user)[:organization]
  end

  def base_issues_url
    "#{github_repository}/issues"
  end

  def issues_url
    "#{base_issues_url}?filter=all&state=all&per_page=100"
  end

  def github_issues current_user
    api = GithubApi.new(current_user.token)
    @github_issues ||= api.get issues_url
  end

  def github_data current_user
    api = GithubApi.new(current_user.token)
    @github_data ||= api.get(github_repository)
  end
end
