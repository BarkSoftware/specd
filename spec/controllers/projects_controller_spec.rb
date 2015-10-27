require 'rails_helper'

RSpec.describe Api::ProjectsController, type: :controller do
  include_context 'existing project'

  before { login_user current_user }

  let(:collaborator) { User.create! uid: junk, email: junk }

  describe '#index' do
    context 'when a collaborator on a project' do
      let(:another_user) { junk_user }
      let!(:collaborator_project) do
        ProjectCreator.new(another_user).create(
          title: junk,
          estimate_type: 'Hours',
          description: junk,
          github_repository: github_repository,
        )
      end

      before do
        collaborator_project.collaborators.create!(
          user: current_user,
          confirmed: true,
        )
      end

      it 'does not accidentally modify the owner of the project' do
        get :index
        expect(collaborator_project.reload.user).to eq(another_user)
      end
    end
  end

  describe '#create' do
    subject { post :create, project: project.as_json }

    let(:result) { JSON.parse(response.body, symbolize_names: true) }
    let(:columns) { Project.find(result[:project][:id]).columns }

    before { |example| subject unless example.metadata[:skip_before] }

    it 'responds with 201' do
      expect(response.status).to eq(201)
    end

    it 'creates project for current user', skip_before: true do
      expect { subject }.to change(current_user.projects, :count).by 1
    end

    it 'returns created project' do
      expect(result[:project][:title]).to eq(project[:title])
    end

    it 'sets up the default columns' do
      expect(columns.size).to eq(4)
      Settings.column_types.each do |column_type|
        expect(columns.find_by(
          title: column_type.title,
        )).to be_present
      end
    end

    it 'puts all open github issues in the starts here column' do
      open_issues = columns.find_by(issues_start_here: true).issues
      expect(open_issues.size).to eq(github_open_issues.count)
    end

    it 'puts closed issues in the closed column' do
      closed_issues = columns.find_by(closed: true).issues
      expect(closed_issues.size).to eq(1)
    end

    it 'github issues with bug label become bug issue types' do
      expect(bug_issue.issue_type).to eq(IssueTypes::BUG)
    end

    it 'github issues with question label become question issue types' do
      expect(question_issue.issue_type).to eq(IssueTypes::QUESTION)
    end

    it 'marks the closed column' do
      expect(columns.find_by(closed: true)).to be_present
    end
  end

  describe '#show' do
    before do
      Collaborator.create!(
        project: project,
        user: collaborator
      )
      get :show, id: project.id
    end

    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    it 'includes collaborators' do
      expect(json[:project][:collaborators].length).to eq 1
    end

    it 'includes owner' do
      expect(json[:project][:owner][:id]).to eq current_user.id
    end

    it 'includes the columns' do
      [
        { ordinal: 0, title: 'Parking Lot' },
        { ordinal: 1, title: 'To Do' },
        { ordinal: 2, title: 'In Progress' },
        { ordinal: 3, title: 'Completed' },
      ].each do |expected_hash|
        expect(json[:project][:columns]).to include(include(expected_hash))
      end
    end
  end
end
