class RenameColumnPlMatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :pl_matches, :match_perf, :match_performance
    rename_column :pl_matches, :player_pos, :player_position
    rename_column :pl_matches, :pos_detail, :player_position_detail
  end
end
