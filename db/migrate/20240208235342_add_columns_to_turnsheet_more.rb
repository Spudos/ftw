class AddColumnsToTurnsheetMore < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :transfer1_type, :string
    add_column :turnsheets, :transfer1_player_id, :integer
    add_column :turnsheets, :transfer1_amount, :integer
    add_column :turnsheets, :transfer2_type, :string
    add_column :turnsheets, :transfer2_player_id, :integer
    add_column :turnsheets, :transfer2_amount, :integer
    add_column :turnsheets, :transfer3_type, :string
    add_column :turnsheets, :transfer3_player_id, :integer
    add_column :turnsheets, :transfer3_amount, :integer
  end
end
