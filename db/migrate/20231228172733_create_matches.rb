class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :match_id
      t.integer :week
      t.string :comp
      t.string :home_team
      t.string :away_team
      t.integer :home_possession
      t.integer :away_possession
      t.integer :home_cha
      t.integer :away_cha
      t.integer :home_chance_on_target
      t.integer :away_chance_on_target
      t.string :home_man_of_the_match
      t.string :away_man_of_the_match
      t.timestamps
    end
  end
end
