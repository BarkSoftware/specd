module Api
  class ColumnsController < BaseController
    def show
      render json: column, status: 200
    end

    def sort_kanban
      params.fetch(:sort).each { |sort| sort_issue sort }
      render json: {}, status: 200
    end

    private

    def column
      @column ||= Column.find(params.fetch(:id)).tap do |column|
        authorize! :read, column.project
      end
    end

    def project
      column.project
    end

    def sort_issue sort
      issue = project.issues.find_by_number(sort.fetch(:number))

      if column.closed? && !issue.column.closed?
        close_issue(issue)
      end

      if column.in_progress? && !issue.column.in_progress?
        assign_issue(issue)
      end

      issue.update_attributes(kanban_sort: sort.fetch(:index), column_id: column.id)
    end

    def assign_issue issue
      GithubApi.new(current_user.token).patch(issue.github_url, { assignee: current_user.nickname })
    end

    def close_issue issue
      GithubApi.new(current_user.token).patch(issue.github_url, { state: 'closed' })
    end
  end
end
