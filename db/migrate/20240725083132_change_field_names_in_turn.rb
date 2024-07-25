class ChangeFieldNamesInTurn < ActiveRecord::Migration[7.0]
  def change
    rename_column :turns, :club_id, :turnsheets
    change_column :turns, :turnsheets, :boolean, default: false
    rename_column :turns, :var1, :turn_actions
    change_column :turns, :turn_actions, :boolean, default: false
    rename_column :turns, :var2, :transfer_actions
    change_column :turns, :transfer_actions, :boolean, default: false
    rename_column :turns, :var3, :auto_selections
    change_column :turns, :auto_selections, :boolean, default: false
    rename_column :turns, :var4, :run_matches
    change_column :turns, :run_matches, :boolean, default: false
    add_column :turns, :create_tables, :boolean, default: false
    add_column :turns, :player_update, :boolean, default: false
    add_column :turns, :transfer_update, :boolean, default: false
    add_column :turns, :upgrade_admin, :boolean, default: false
    add_column :turns, :club_update, :boolean, default: false
    add_column :turns, :article_update, :boolean, default: false
  end
end
