class CreateGoalsAndAssistsByMatch < ActiveRecord::Migration[7.0]
  def change
    create_table :goals_and_assists_by_matches do |t|
      t.integer :match_id
      t.integer :week_number
      t.integer :minute
      t.integer :assist
      t.integer :scorer

      t.timestamps
    end
  end
end
