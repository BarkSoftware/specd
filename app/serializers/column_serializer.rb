class ColumnSerializer < ActiveModel::Serializer
  attributes :id, :title, :ordinal, :issues

  delegate :project, to: :object

  def issues
    object.issues.all.order(:kanban_sort).as_json.map do |issue|
      map_issue issue
    end
  end

  private

  def map_issue issue
    issue.deep_symbolize_keys!.tap do |issue|
      issue.merge!(project_id: project.id)
      project.github_issues(scope).each do |github_issue|
        issue.merge!(github: github_issue) if issue[:number] == github_issue[:number]
      end
    end
  end
end
