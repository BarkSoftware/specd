class WebhookProcessor
  def initialize project, webhook
    @project = project
    @webhook = webhook
  end

  attr_reader :webhook, :project

  def process
    create_or_close_if_existing if action == 'closed'
    create_or_reopen_if_existing if action == 'reopened'

    if action == 'opened'
      unless issue_exists?
        project.columns.parking_lot.first.issues.create!(
          number: webhook[:issue][:number],
          kanban_sort: 0,
        )
      end
    end
  end

  def create_or_close_if_existing
    if issue_exists?
      issue.move_to project.columns.closed.first
    else
      project.columns.closed.first.create!(
        number: webhook[:issue][:number],
        kanban_sort: 0,
      )
    end
  end

  def create_or_reopen_if_existing
    if issue_exists?
      issue.move_to project.columns.in_progress.first
    else
      project.columns.in_progress.first.issues.create!(
        number: webhook[:issue][:number],
        kanban_sort: 0,
      )
    end
  end

  def action
    webhook[:action]
  end

  def issue
    project.issues.find_by_number(webhook[:issue][:number])
  end

  def issue_exists?
    project.issues.exists?(number: webhook[:issue][:number])
  end
end
