class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :match_id
      t.integer :week
      t.string :comp
      t.string :hm_team
      t.string :aw_team
      t.integer :hm_poss
      t.integer :aw_poss
      t.integer :hm_cha
      t.integer :aw_cha
      t.integer :hm_cha_on_tar
      t.integer :aw_cha_on_tar
      t.string :hm_motm
      t.string :aw_motm
      t.timestamps
    end
  end
end
