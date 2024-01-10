class AddPlayerPosToPlMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_matches, :player_pos, :string
    add_column :pl_matches, :pos_detail, :string
  end
end
