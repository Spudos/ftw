class CreateGameParams < ActiveRecord::Migration[7.0]
  def change
    create_table :game_params do |t|
      t.integer :chance_factor
      t.integer :midfield_on_attack

      t.timestamps
    end
  end
end
