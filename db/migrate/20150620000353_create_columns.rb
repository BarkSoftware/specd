class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :title
      t.references :project, index: true
      t.string :column_type
      t.integer :ordinal

      t.timestamps
    end
  end
end
