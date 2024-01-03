class CreatePlStatsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :pl_stats do |t|
      t.integer :player_id
      t.integer :goals
      t.integer :assists
      t.integer :motm

      t.timestamps
    end

    add_foreign_key :pl_stats, :players, column: :player_id
  end
end
