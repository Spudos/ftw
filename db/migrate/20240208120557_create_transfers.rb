class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.integer :player_id
      t.integer :sell_club
      t.integer :buy_club
      t.integer :week
      t.integer :bid

      t.timestamps
    end
  end
end
