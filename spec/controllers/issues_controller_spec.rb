require 'rails_helper'

RSpec.describe Api::IssuesController, type: :controller do
  include_context 'existing project'

  before { login_user current_user }

  let(:issue_type) { 'spec' }
  let(:column) { parking_lot }
  let(:number) { 42 }
  let(:issue) do
    {
      title: title,
    }
  end

  junklet :title

  describe '#create' do
    let!(:post_issue_stub) do
      stub_request(:post, github_repo_pattern('issues')).to_return(
        status: 201,
        body: {
          number: number,
          issue_type: issue_type,
          title: title,
          project_id: project.id,
        }.to_json,
      )
    end

    let!(:get_issue_stub) do
      stub_request(:get, github_repo_pattern("issues/#{number}")).to_return(
        status: 200,
        body: {
          number: number,
          title: title,
        }.to_json,
      )
    end

    let(:issue_post_params) do
      {
        issue_type: IssueTypes::SPEC,
        column_id: column.id,
        issue: issue,
      }
    end

    before { post :create, issue_post_params }

    it 'puts the issue in the cooresponding column' do
      expect(Issue.last.column).to eq(parking_lot)
    end

    it 'creates an issue on github' do
      expect(post_issue_stub.with do |req|
        expect(JSON.parse(req.body, symbolize_names: true)[:title]).to eq(title)
      end).to have_been_requested
    end

    it 'labels the issue with the issue type' do
      expect(post_issue_stub.with do |req|
        expect(JSON.parse(req.body, symbolize_names: true)[:labels]).to eq(['spec'])
      end).to have_been_requested
    end

    it 'returns the created issue' do
      expect(JSON.parse(response.body, symbolize_names: true)[:issue]).to include(
        number: number,
        issue_type: IssueTypes::SPEC,
        project_id: project.id,
      )
    end

    it 'puts the issue at the top of the list' do
      expect(Issue.last.kanban_sort).to eq(-1)
    end

    context 'when the issue type is a bug' do
      let(:issue_post_params) { super().merge(issue_type: IssueTypes::BUG) }
      it 'saves the correct issue type' do
        expect(Issue.last.issue_type).to eq(IssueTypes::BUG)
      end
    end

    context 'when the column is in progress' do
      let(:column) { in_progress }
      it 'assigns the user automatically' do
        expect(post_issue_stub.with do |req|
          expect(JSON.parse(req.body, symbolize_names: true)[:assignee]).to eq(current_user.nickname)
        end).to have_been_requested
      end
    end
  end
end
