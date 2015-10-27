require 'rails_helper'

RSpec.describe 'issues requests', type: :request do
  include_context 'existing project'

  before do
    login_as current_user
  end

  let(:issue) { parking_lot_issue }

  describe '#show' do
    it 'includes the estimate value' do
      issue.update_attributes(estimate: 1)
      get api_issue_path(issue)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:issue][:estimate]).to eq(1)
    end

    it 'includes the issue type' do
      get api_issue_path(issue)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:issue][:issue_type]).to eq('Spec')
    end

    it 'includes the estimate type from project' do
      get api_issue_path(issue)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:issue][:estimate_type]).to eq('Hours')
    end

    it 'uses number to find issue when project_id present' do
      get "/api/projects/#{issue.project.id}/issues/#{issue.number}"
      expect(response.body).to include('Hours')
    end
  end

  describe '#update' do
    it 'updates the estimate on an issue' do
      patch api_issue_path(issue), { issue: { estimate: 1.5 } }
      updated_issue = Issue.find(issue.id)
      expect(updated_issue.estimate).to eq(1.5)
    end

    it 'updates the issue_type on an issue' do
      patch api_issue_path(issue), { issue_type: 'Bug' }
      updated_issue = Issue.find(issue.id)
      expect(updated_issue.issue_type).to eq(IssueTypes::BUG)
    end
  end
end
