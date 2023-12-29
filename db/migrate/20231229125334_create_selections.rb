class CreateSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :selections do |t|
      t.string :club
      t.integer :player_id

      t.timestamps
    end
  end
end
