class ProjectSerializer < ActiveModel::Serializer
  attributes  :id,
              :title,
              :description,
              :github_repository,
              :estimate_type,
              :cost_method,
              :owner,
              :collaborators,
              :created_at,
              :columns,
              :archived,
              :completion_percent

  def owner
    object.user
  end

  def columns
    object.columns.order(:ordinal).all.map { |c| c.slice :id, :ordinal, :title, :closed }
  end

  def collaborators
    object.collaborators.map { |c| c.as_json }
  end

  def completion_percent
    todo_count = object.columns.todo.flat_map(&:issues).count
    in_progress_count = object.columns.in_progress.flat_map(&:issues).count
    closed_count = object.columns.closed.flat_map(&:issues).count
    total = todo_count + in_progress_count + closed_count
    return 100 if total == 0
    (closed_count.to_f / total.to_f * 100).round
  end
end
