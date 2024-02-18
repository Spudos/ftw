class CreatePlStatsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :pl_statistics do |t|
      t.integer :player_id
      t.integer :goals
      t.integer :assists
      t.integer :man_of_the_match

      t.timestamps
    end

    add_foreign_key :pl_statistics, :players, column: :player_id
  end
end
