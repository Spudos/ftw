class RenameColumnsInPlayers < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :goals, :total_goals
    rename_column :players, :assists, :total_assists
  end
end
