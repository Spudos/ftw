class CreateSquadActions < ActiveRecord::Migration[7.0]
  def change
    create_table :squad_actions do |t|
      t.integer :club_id
      t.string :action
      t.string :position
      t.integer :amount
      t.timestamps
    end
  end
end
