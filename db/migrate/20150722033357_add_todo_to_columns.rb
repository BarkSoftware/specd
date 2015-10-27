class AddTodoToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :todo, :boolean
  end
end
