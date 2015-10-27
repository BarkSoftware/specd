class AddTypeToCollaborators < ActiveRecord::Migration
  def change
    add_column :collaborators, :type, :string
  end
end
