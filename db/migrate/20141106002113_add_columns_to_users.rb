class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :image, :string
    add_column :users, :nickname, :string
  end
end
