class AddMoreConfigToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :issues_start_here, :boolean
    remove_column :columns, :column_type
  end
end
