class RemoveColumnsFromTurnsheets < ActiveRecord::Migration[7.0]
  def change
    remove_column :turnsheets, :player_action_1
    remove_column :turnsheets, :player_action_2
    remove_column :turnsheets, :player_action_3
    remove_column :turnsheets, :player_action_4
    remove_column :turnsheets, :player_action_1_player_id
    remove_column :turnsheets, :player_action_2_player_id
    remove_column :turnsheets, :player_action_3_player_id
    remove_column :turnsheets, :player_action_4_player_id
    remove_column :turnsheets, :player_action_1_var
    remove_column :turnsheets, :player_action_2_var
    remove_column :turnsheets, :player_action_3_var
    remove_column :turnsheets, :player_action_4_var
  end
end
