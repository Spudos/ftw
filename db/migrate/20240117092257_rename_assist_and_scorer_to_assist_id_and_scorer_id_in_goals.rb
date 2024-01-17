class RenameAssistAndScorerToAssistIdAndScorerIdInGoals < ActiveRecord::Migration[7.0]
  def change
    rename_column :goals, :assist, :assist_id
    rename_column :goals, :scorer, :scorer_id
  end
end
