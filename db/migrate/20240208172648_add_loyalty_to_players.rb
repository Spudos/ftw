class AddLoyaltyToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :loyalty, :integer
  end
end
