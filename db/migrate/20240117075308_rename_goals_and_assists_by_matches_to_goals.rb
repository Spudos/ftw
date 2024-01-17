class RenameGoalsAndAssistsByMatchesToGoals < ActiveRecord::Migration[7.0]
  def change
    rename_table :goals_and_assists_by_matches, :goals
    rename_table :player_match_data, :performances
  end
end
