class ChangeNameOfGameParams < ActiveRecord::Migration[7.0]
  def change
    rename_table :game_params, :configurations
    add_column :configurations, :target_factor, :integer
    add_column :configurations, :goal_factor, :integer
  end
end
