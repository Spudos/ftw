class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.string :nationality
      t.string :pos
      t.integer :pa
      t.integer :co
      t.integer :ta
      t.integer :ru
      t.integer :sh
      t.integer :dr
      t.integer :df
      t.integer :of
      t.integer :fl
      t.integer :st
      t.integer :cr
      t.integer :fit
      t.timestamps
    end
  end
end
