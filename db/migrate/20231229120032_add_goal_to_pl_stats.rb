class AddGoalToPlstatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_statistics, :goal, :boolean
    add_column :pl_statistics, :assist, :boolean
  end
end
