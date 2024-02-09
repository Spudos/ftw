class AddColumnsToplayers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :transfer_type, :string
    add_column :transfers, :transfer_player_id, :integer
    add_column :transfers, :transfer_amount, :integer
  end
end
