class AddTurnsheetIdToScoutings < ActiveRecord::Migration[7.0]
  def change
    add_column :scoutings, :turnsheet_id, :integer
  end
end
