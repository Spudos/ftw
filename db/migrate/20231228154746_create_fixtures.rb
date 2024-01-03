class CreateFixtures < ActiveRecord::Migration[7.0]
  def change
    create_table :fixtures do |t|
      t.integer :match_id
      t.integer :week_number
      t.string :home
      t.string :away
      t.string :comp

      t.timestamps
    end
  end
end
