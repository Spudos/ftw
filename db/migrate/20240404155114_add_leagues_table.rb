class AddLeaguesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.integer :club_id

      t.timestamps
    end
  end
end
