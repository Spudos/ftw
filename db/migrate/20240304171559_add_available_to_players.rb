class AddAvailableToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :available, :integer
  end
end
