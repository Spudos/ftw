class CreateCommentary < ActiveRecord::Migration[7.0]
  def change
    create_table :commentaries do |t|
      t.string :game_id
      t.integer :minute
      t.text :commentary
      t.timestamps
    end
  end
end
