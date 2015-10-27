class AddEstimateInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :estimate_type, :string
    add_column :projects, :cost_method, :string
  end
end
