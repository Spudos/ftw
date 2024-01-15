class CreatePlayerMatchData < ActiveRecord::Migration[7.0]
  def change
    create_table :player_match_data do |t|
      t.integer :id
      t.integer :player_id
      t.string :club
      t.string :name
      t.string :player_position
      t.string :player_position_detail
      t.integer :match_performance

      t.timestamps
    end
  end
end
