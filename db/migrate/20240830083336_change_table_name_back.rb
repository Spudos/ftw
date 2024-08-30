class ChangeTableNameBack < ActiveRecord::Migration[7.0]
  def change
    rename_table :configurations, :game_params
  end
end
