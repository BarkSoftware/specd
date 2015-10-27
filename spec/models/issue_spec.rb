require 'rails_helper'

RSpec.describe Issue do
  it "defaults issue_type to '#{IssueTypes::SPEC}'" do
    Issue.create!.tap do |issue|
      expect(issue.issue_type).to eq(IssueTypes::SPEC)
    end
  end
end
