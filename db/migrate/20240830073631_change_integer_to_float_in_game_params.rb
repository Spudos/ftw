class ChangeIntegerToFloatInGameParams < ActiveRecord::Migration[7.0]
  def change
    change_column :game_params, :midfield_on_attack, :float
    change_column :game_params, :chance_factor, :float
  end
end
