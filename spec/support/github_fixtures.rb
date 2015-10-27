shared_context 'github fixtures' do
  junklet :github_username, :repository_name
  let(:github_repository) { "https://api.github.com/repos/#{github_username}/#{repository_name}" }

  def github_repo_pattern path
    Regexp.new "#{github_repository.gsub('https://', '')}/#{path}"
  end

  let(:get_user_json) do
    fixture('github', 'get_user.json').read
  end

  let!(:get_user_stub) do
    stub_github_request(:get, 'user', get_user_json)
  end

  let(:get_repository_json) do
    JSON.parse(fixture('github', 'get_repo.json').read, symbolize_names: true)
  end

  let!(:get_repository_stub) do
    stub_github_request(:get, "repos/#{github_username}/#{repository_name}$", get_repository_json.to_json)
  end

  let(:get_issues_json) do
    (github_open_issues + [github_closed_issue]).to_json
  end

  let(:github_open_issues) do
    [
      github_parking_lot_issue,
      github_todo_issue,
      github_in_progress_issue,
      github_bug_issue,
      github_question_issue,
    ]
  end

  let(:issue_data) do
    JSON.parse(fixture('github', 'issue.json').read, symbolize_names: true)
  end

  let(:github_parking_lot_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'open'
      issue[:number] = '1'
      issue[:title] = 'Parking Lot Issue'
      issue[:description] = 'testing parking lot issue'
    end
  end

  let(:github_todo_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'open'
      issue[:number] = '2'
      issue[:title] = 'ToDo Issue'
      issue[:description] = 'testing to-do issue'
    end
  end

  let(:github_in_progress_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'open'
      issue[:number] = '3'
      issue[:title] = 'In Progress Issue'
      issue[:description] = 'testing in progress issue'
    end
  end

  let(:github_closed_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'closed'
      issue[:number] = '4'
      issue[:title] = 'Closed Issue'
      issue[:description] = 'testing closed issue'
    end
  end

  let(:github_bug_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'open'
      issue[:labels] = [{
          color: "000000",
          name: "Bug",
      }]
      issue[:number] = '5'
      issue[:title] = 'Bug Issue'
      issue[:description] = 'testing bug issue'
    end
  end

  let(:github_question_issue) do
    issue_data.dup.tap do |issue|
      issue[:state] = 'open'
      issue[:labels] = [{
          color: "000000",
          name: "Question",
      }]
      issue[:number] = '6'
      issue[:title] = 'Question Issue'
      issue[:description] = 'testing question issue'
    end
  end

  [
    'parking_lot',
    'todo',
    'in_progress',
    'closed',
  ].each do |issue_name|
    let!("get_#{issue_name}_issue_stub".to_sym) do
      issue = send("github_#{issue_name}_issue".to_sym)
      stub_github_request(:get, "repos/#{github_username}/#{repository_name}/issues/#{issue.fetch(:number)}$", issue.to_json)
    end
  end

  let!(:get_issues_stub) do
    stub_github_request(:get,
                        "repos/#{github_username}/#{repository_name}/issues\\?filter=all&per_page=100&state=all$",
                        get_issues_json)
  end

  let!(:create_webhook_stub) do
    stub_github_request(:post, "repos/#{github_username}/#{repository_name}/hooks", {}.to_json)
  end

  let(:webhooks) do
    [
      {
        url: "https://api.github.com/repos/BrandonJoyce356/specd-testing/hooks/5363939",
        test_url: "https://api.github.com/repos/BrandonJoyce356/specd-testing/hooks/5363939/test",
        ping_url: "https://api.github.com/repos/BrandonJoyce356/specd-testing/hooks/5363939/pings",
        id: 5363939,
        name: "web",
        active: true,
        events: ['*'],
        config: {
          url: "#{Settings.host}/api/webhooks?project_id=1",
          content_type: "json",
          secret: "********",
          insecure_ssl: "1"
        },
        last_response: { code: 200, status: "active", message: "OK" },
        updated_at: "2015-07-22T00:45:12Z",
        created_at: "2015-07-22T00:39:06Z",
      }
    ]
  end

  let!(:get_webhooks_stub) do
    stub_github_request(:get, "repos/#{github_username}/#{repository_name}/hooks", webhooks.to_json)
  end

  def stub_github_request method, path, json, options = {}
    stub_request(method, %r{api.github.com/#{path}}).to_return(
      status: options[:status] || 200,
      body: json,
    )
  end
end
