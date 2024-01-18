class AddContractToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :contract, :integer, default: 24
  end
end
