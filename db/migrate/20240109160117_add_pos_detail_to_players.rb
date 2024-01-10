class AddPosDetailToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :pos_detail, :string
  end
end
