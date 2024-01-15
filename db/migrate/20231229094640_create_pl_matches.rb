class CreatePlMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :pl_matches do |t|
      t.integer :id
      t.integer :player_id
      t.integer :match_performance

      t.timestamps
    end

    add_foreign_key :pl_matches, :players, column: :player_id
  end
end

