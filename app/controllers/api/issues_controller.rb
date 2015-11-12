module Api
  class IssuesController < BaseController
    def show
      @issue = Issue.find(params[:id])
      authorize! :read, @issue
      render json: @issue, status: 200
    end

    def show_by_number
      @issue = Issue.where(number: params[:number])
        .includes(:column)
        .where(columns: { project_id: params[:project_id] })
        .first
      authorize! :read, issue
      render json: issue, status: 200
    end

    def create
      authorize! :update, Issue
      create_github_issue.tap do |github_issue|
        @issue = column.issues.create(issue_params.merge(number: github_issue[:number]))
      end
      render json: issue, status: 201
    end

    def update
      authorize! :update, issue
      @column = issue.column
      issue.update!(issue_params)
      render json: issue, status: 200
    end

    private

    attr_reader :issue

    def create_github_issue
      github_api.post(project.base_issues_url, create_github_issue_params)
    end

    def create_github_issue_params
      params[:issue].slice(:title, :body).tap do |data|
        data.merge!(labels: [params.fetch(:issue_type).downcase])
        data.merge!(assignee: current_user.nickname) if column.in_progress?
      end
    end

    def issue_params
      {
        estimate: params[:estimate] || params[:issue].andand[:estimate],
        issue_type: params[:issue_type] || params[:issue].andand[:issue_type],
        kanban_sort: (column.issues.minimum(:kanban_sort) || 0) - 1,
        column_id: params[:issue].andand[:column_id],
      }.reject { |_, v| v.blank? }
    end

    def column
      @column ||= Column.find(params.fetch(:column_id)).tap do |column|
        authorize! :read, column.project
      end
    end

    def project
      column.project
    end

    def issue
      @issue ||= Issue.find(params[:id])
    end

    def github_api
      GithubApi.new(current_user.token)
    end
  end
end
