class AddColumnsToDb < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :transfer_type, :string
    add_column :turnsheets, :transfer_player_id, :integer
    add_column :turnsheets, :transfer_amount, :integer

    remove_column :turnsheets, :transfer_type, :string
    remove_column :transfers, :transfer_player_id, :integer
    remove_column :transfers, :transfer_amount, :integer

    drop_table :transfers_tables
  end
end
