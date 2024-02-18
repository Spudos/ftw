class CreateTactics < ActiveRecord::Migration[7.0]
  def change
    create_table :tactics do |t|
      
      t.string :club_id
      t.integer :tactics
      t.timestamps
    end
  end
end
