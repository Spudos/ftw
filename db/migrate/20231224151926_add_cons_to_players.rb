class AddConsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :cons, :integer
  end
end
