class AddKanbanStatusToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :kanban_status, :string
  end
end
