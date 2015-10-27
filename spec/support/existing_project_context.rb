shared_context 'existing project' do
  include_context 'github fixtures'

  before do
    login_as current_user
  end

  let(:current_user) { junk_user }
  let!(:project) do
    ProjectCreator.new(current_user).create(
      title: junk,
      estimate_type: 'Hours',
      description: junk,
      github_repository: github_repository,
    )
  end
  let(:parking_lot) { project.columns.parking_lot.first }
  let(:closed) { project.columns.closed.first }
  let(:in_progress) { project.columns.in_progress.first }
  # todo column does nothing special so we find it by title
  let(:todo) { project.columns.find_by_title('To Do') }

  let!(:parking_lot_issue) do
    project.issues.find_by_number(github_parking_lot_issue[:number]).tap do |issue|
      issue.move_to parking_lot
    end
  end

  let!(:todo_issue) do
    project.issues.find_by_number(github_todo_issue[:number]).tap do |issue|
      issue.move_to todo
    end
  end

  let!(:in_progress_issue) do
    project.issues.find_by_number(github_in_progress_issue[:number]).tap do |issue|
      issue.move_to in_progress
    end
  end

  let!(:closed_issue) do
    project.issues.find_by_number(github_closed_issue[:number]).tap do |issue|
      issue.move_to closed
    end
  end

  let!(:bug_issue) do
    project.issues.find_by_number(github_bug_issue[:number]).tap do |issue|
      issue.move_to parking_lot
    end
  end

  let!(:question_issue) do
    project.issues.find_by_number(github_question_issue[:number]).tap do |issue|
      issue.move_to parking_lot
    end
  end

end
