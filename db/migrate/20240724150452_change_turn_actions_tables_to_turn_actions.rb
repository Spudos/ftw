class ChangeTurnActionsTablesToTurnActions < ActiveRecord::Migration[7.0]
  def change
    rename_table :turn_actions_tables, :turn_actions
  end
end
