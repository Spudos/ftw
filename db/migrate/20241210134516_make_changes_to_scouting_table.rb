class MakeChangesToScoutingTable < ActiveRecord::Migration[7.0]
  def change
    change_column_default :scoutings, :blend_player, from: nil, to: 0
    change_column_default :scoutings, :skills_value, from: nil, to: 0
    change_column_default :scoutings, :potential_skill_value, from: nil, to: 0
    remove_column :scoutings, :week
    remove_column :scoutings, :club_id
  end
end
