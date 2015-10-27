class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.integer :number
      t.decimal :estimate

      t.timestamps
    end
  end
end
