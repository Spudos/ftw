class AddTotalsToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :total_skill, :integer
    add_column :players, :games_played, :integer
    add_column :players, :goals, :integer
    add_column :players, :assists, :integer
    add_column :players, :average_performance, :integer
  end
end
