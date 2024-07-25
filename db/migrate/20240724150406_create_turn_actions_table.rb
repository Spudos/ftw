class CreateTurnActionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :turn_actions_tables do |t|
      t.integer :week
      t.string :club_id
      t.string :var1
      t.string :var2
      t.string :var3
      t.string :var4

      t.timestamps
    end
  end
end
