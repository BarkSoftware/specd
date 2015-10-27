class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :project_id
      t.string :email
      t.string :invite_token
      t.boolean :accepted
      t.integer :user_id

      t.timestamps
    end
  end
end
