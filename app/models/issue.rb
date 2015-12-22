class Issue < ActiveRecord::Base
  belongs_to :column
  before_create :default_issue_type
  validates_uniqueness_of :number, :scope => :project_id

  delegate :project, to: :column
  attr_accessor :github_issue

  def self.dedupe
    grouped = all.group_by{|model| [model.project_id, model.number] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

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
