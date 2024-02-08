class AddValueToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :value, :integer
    add_column :players, :wages, :integer
    add_column :players, :parent, :text
  end
end
