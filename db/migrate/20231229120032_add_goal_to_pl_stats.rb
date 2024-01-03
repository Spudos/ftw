class AddGoalToPlStats < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_stats, :goal, :boolean
    add_column :pl_stats, :assist, :boolean
  end
end
