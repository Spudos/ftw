class CreateTurnsheets < ActiveRecord::Migration[7.0]
  def change
    create_table :turnsheets do |t|
      t.integer :week
      t.string :club
      t.string :manager
      t.string :email
      t.string :player_1
      t.string :player_2
      t.string :player_3
      t.string :player_4
      t.string :player_5
      t.string :player_6
      t.string :player_7
      t.string :player_8
      t.string :player_9
      t.string :player_10
      t.string :player_11
      t.string :stad_upg
      t.string :coach_upg
      t.string :train_gkp
      t.string :train_gkp_skill
      t.string :train_dfc
      t.string :train_dfc_skill
      t.string :train_mid
      t.string :train_mid_skill
      t.string :train_att
      t.string :train_att_skill
      t.timestamps
    end
  end
end
