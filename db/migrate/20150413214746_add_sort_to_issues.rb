class AddSortToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :kanban_sort, :integer
  end
end
