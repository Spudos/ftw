class AddNewScoutingsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :scoutings do |t|
      t.integer :week
      t.integer :club_id
      t.string :position
      t.integer :total_skill
      t.integer :age
      t.boolean :skills
      t.integer :skills_value
      t.boolean :loyalty
      t.boolean :potential_skill
      t.integer :potential_skill_value
      t.boolean :consistency
      t.boolean :recovery
      t.boolean :star
      t.integer :blend_player

      t.timestamps
    end
  end
end
