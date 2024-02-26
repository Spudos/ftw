class AddNotNullFieldToPlayers < ActiveRecord::Migration[7.0]
  def change
    change_column :players, :value, :integer, null: false, default: 0
    change_column :players, :wages, :integer, null: false, default: 0
    change_column :players, :total_skill, :integer, null: false, default: 0
    change_column :players, :games_played, :integer, null: false, default: 0
    change_column :players, :total_goals, :integer, null: false, default: 0
    change_column :players, :total_assists, :integer, null: false, default: 0
    change_column :players, :average_performance, :integer, null: false, default: 0
  end
end
