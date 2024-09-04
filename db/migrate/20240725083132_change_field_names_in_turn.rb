class ChangeFieldNamesInTurn < ActiveRecord::Migration[7.0]
  def change
    rename_column :turns, :club_id, :turnsheets
    change_column :turns, :turnsheets, :boolean, default: false, using: 'turnsheets::boolean'
    rename_column :turns, :var1, :turn_actions
    change_column :turns, :turn_actions, :boolean, default: false, using: 'turn_actions::boolean'
    rename_column :turns, :var2, :transfer_actions
    change_column :turns, :transfer_actions, :boolean, default: false, using: 'transfer_actions::boolean'
    rename_column :turns, :var3, :auto_selections
    change_column :turns, :auto_selections, :boolean, default: false, using: 'auto_selections::boolean'
    rename_column :turns, :var4, :run_matches
    change_column :turns, :run_matches, :boolean, default: false, using: 'run_matches::boolean'
    add_column :turns, :create_tables, :boolean, default: false, using: 'create_tables::boolean'
    add_column :turns, :player_update, :boolean, default: false, using: 'player_update::boolean'
    add_column :turns, :transfer_update, :boolean, default: false, using: 'transfer_update::boolean'
    add_column :turns, :upgrade_admin, :boolean, default: false, using: 'upgrade_admin::boolean'
    add_column :turns, :club_update, :boolean, default: false, using: 'club_update::boolean'
    add_column :turns, :article_update, :boolean, default: false,   using: 'article_update::boolean'
  end
end
