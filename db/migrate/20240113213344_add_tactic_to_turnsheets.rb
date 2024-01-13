class AddTacticToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :tactic, :integer
  end
end
