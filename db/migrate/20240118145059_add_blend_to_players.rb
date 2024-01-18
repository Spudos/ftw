class AddBlendToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :blend, :integer
  end
end
