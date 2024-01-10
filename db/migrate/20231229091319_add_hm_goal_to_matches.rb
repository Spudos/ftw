class AddHmGoalToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :home_goals, :integer
    add_column :matches, :away_goals, :integer
  end
end
