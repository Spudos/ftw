class AddHmGoalToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :hm_goal, :integer
    add_column :matches, :aw_goal, :integer
  end
end
