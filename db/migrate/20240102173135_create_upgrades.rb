class CreateUpgrades < ActiveRecord::Migration[7.0]
  def change
    create_table :upgrades do |t|
      t.integer :week
      t.string :club
      t.string :var1
      t.string :var2

      t.timestamps
    end
  end
end
