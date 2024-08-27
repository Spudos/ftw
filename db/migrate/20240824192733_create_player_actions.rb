class CreatePlayerActions < ActiveRecord::Migration[7.0]
  def change
    create_table :player_actions do |t|
      t.references :turnsheet, null: false, foreign_key: true
      t.string :type
      t.string :player_id
      t.integer :amount
      t.timestamps
    end
  end
end
