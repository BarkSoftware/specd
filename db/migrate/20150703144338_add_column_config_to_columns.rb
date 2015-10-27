class AddColumnConfigToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :in_progress, :boolean
    add_column :columns, :closed, :boolean
  end
end
