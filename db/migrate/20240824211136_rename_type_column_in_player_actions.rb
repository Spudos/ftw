class RenameTypeColumnInPlayerActions < ActiveRecord::Migration[7.0]
  def change
    rename_column :player_actions, :type, :action
  end
end
