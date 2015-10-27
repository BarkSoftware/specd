require 'rails_helper'

RSpec.describe Api::ColumnsController, type: :controller do
  include_context 'existing project'

  before { login_user current_user }

  def stub_patch_issue issue
    stub_request(:patch, github_repo_pattern("issues/#{issue.number}")).to_return(
      status: 200,
      body: {}.to_json,
    )
  end

  let!(:patch_in_progress_issue_stub) { stub_patch_issue(in_progress_issue) }
  let!(:patch_todo_issue_stub) { stub_patch_issue(todo_issue) }

  context 'when moving an item to a closed column' do

    let(:sort) { [{ number: in_progress_issue.number, index: 0 }] }

    before do
      post :sort_kanban, { id: closed }.merge(sort: sort)
    end

    it 'closes the issue with github api' do
      expect(patch_in_progress_issue_stub.with do |req|
        expect(JSON.parse(req.body, symbolize_names: true)[:state]).to eq 'closed'
      end).to have_been_requested
    end
  end

  context 'when moving an item to the in progress column' do
    let(:sort) { [{ number: todo_issue.number, index: 0 }] }
    before do
      post :sort_kanban, { id: in_progress }.merge(sort: sort)
    end

    it 'assigns the current user automatically' do
      expect(patch_todo_issue_stub.with do |req|
        expect(JSON.parse(req.body, symbolize_names: true)[:assignee]).to eq current_user.nickname
      end).to have_been_requested
    end
  end
end
