class AddTlToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :TL, :integer, default: 0
  end
end
