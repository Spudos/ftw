class AddCompetitionToGoalsAndAssistsByMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :goals_and_assists_by_matches, :competition, :string
  end
end
