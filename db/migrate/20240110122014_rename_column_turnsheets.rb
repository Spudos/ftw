class RenameColumnTurnsheets < ActiveRecord::Migration[7.0]
  def change
    rename_column :turnsheets, :stad_upg, :stadium_upgrade
    rename_column :turnsheets, :coach_upg, :coach_upgrade
    rename_column :turnsheets, :train_gkp, :train_goalkeeper
    rename_column :turnsheets, :train_dfc, :train_defender
    rename_column :turnsheets, :train_mid, :train_midfielder
    rename_column :turnsheets, :train_att, :train_attacker
    rename_column :turnsheets, :train_gkp_skill, :train_goalkeeper_skill
    rename_column :turnsheets, :train_dfc_skill, :train_defender_skill
    rename_column :turnsheets, :train_mid_skill, :train_midfielder_skill
    rename_column :turnsheets, :train_att_skill, :train_attacker_skill
    rename_column :turnsheets, :stad_amt, :stadium_amount
    rename_column :turnsheets, :prop_upg, :property_upgrade
    rename_column :turnsheets, :stad_cond_upg, :stadium_condition_upgrade
  end
end
