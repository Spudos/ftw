class CreateTurns < ActiveRecord::Migration[7.0]
  def change
    create_table :turns do |t|
      t.integer :week
      t.string :club
      t.string :var1
      t.string :var2
      t.string :var3

      t.timestamps
    end
  end
end
