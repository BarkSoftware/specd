class AddIssueTypeToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :issue_type, :string
  end
end
