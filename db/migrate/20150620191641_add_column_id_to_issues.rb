class AddColumnIdToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :column_id, :integer
    add_index :issues, :column_id
  end
end
