class AddPlayerActionToTurnsheet < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :player_action_1, :string
    add_column :turnsheets, :player_action_1_player_id, :integer
    add_column :turnsheets, :player_action_1_var, :string
    add_column :turnsheets, :player_action_2, :string
    add_column :turnsheets, :player_action_2_player_id, :integer
    add_column :turnsheets, :player_action_2_var, :string
    add_column :turnsheets, :player_action_3, :string
    add_column :turnsheets, :player_action_3_player_id, :integer
    add_column :turnsheets, :player_action_3_var, :string
    add_column :turnsheets, :player_action_4, :string
    add_column :turnsheets, :player_action_4_player_id, :integer
    add_column :turnsheets, :player_action_4_var, :string
  end
end
