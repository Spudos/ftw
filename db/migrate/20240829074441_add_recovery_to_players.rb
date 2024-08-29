class AddRecoveryToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :recovery, :integer, default: 0
  end
end
