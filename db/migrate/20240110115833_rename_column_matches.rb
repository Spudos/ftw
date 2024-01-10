class RenameColumnMatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :matches, :hm_team, :home_team
    rename_column :matches, :aw_team, :away_team
    rename_column :matches, :hm_possession, :home_possessionession
    rename_column :matches, :aw_possession, :away_possessionession
    rename_column :matches, :hm_cha, :home_chance
    rename_column :matches, :aw_cha, :away_chance
    rename_column :matches, :hm_chance_on_target, :home_chance_on_target
    rename_column :matches, :aw_chance_on_target, :away_chance_on_target
    rename_column :matches, :hm_man_of_the_match, :home_man_of_the_match
    rename_column :matches, :aw_man_of_the_match, :away_man_of_the_match
    rename_column :matches, :hm_goal, :home_goalss
    rename_column :matches, :aw_goal, :away_goalss
end
end
