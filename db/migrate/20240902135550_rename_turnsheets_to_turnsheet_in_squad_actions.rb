class RenameTurnsheetsToTurnsheetInSquadActions < ActiveRecord::Migration[7.0]
  def change
    rename_column :squad_actions, :turnsheets_id, :turnsheet_id
  end
end
