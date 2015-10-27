class RenameAccepted < ActiveRecord::Migration
  def change
    rename_column :collaborators, :accepted, :confirmed
  end
end
