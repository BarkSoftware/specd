class Issue < ActiveRecord::Base
  belongs_to :column
  before_create :default_issue_type

  delegate :project, to: :column
  attr_accessor :github_issue

  def move_to column
    self.column = column
    save!
  end

  def default_issue_type
    self.issue_type = IssueTypes::SPEC if self.issue_type.blank?
  end

  def github_url
    "#{project.github_repository}/issues/#{number}"
  end
end
