class RenameColumnPlayers < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :pos, :position
    rename_column :players, :pa, :passing
    rename_column :players, :co, :control
    rename_column :players, :ru, :running
    rename_column :players, :ta, :tackling
    rename_column :players, :sh, :shooting
    rename_column :players, :dr, :dribbling
    rename_column :players, :df, :defensive_heading
    rename_column :players, :of, :offensive_heading
    rename_column :players, :fl, :flair
    rename_column :players, :st, :strength
    rename_column :players, :cr, :creatvitiy
    rename_column :players, :fit, :fitness
    rename_column :players, :cons, :consistency
    rename_column :players, :pos_detail, :player_position_detail
    rename_column :players, :potential_pa, :potential_passing
    rename_column :players, :potential_co, :potential_control
    rename_column :players, :potential_ru, :potential_running
    rename_column :players, :potential_ta, :potential_tackling
    rename_column :players, :potential_sh, :potential_shooting
    rename_column :players, :potential_dr, :potential_dribbling
    rename_column :players, :potential_df, :potential_defensive_heading
    rename_column :players, :potential_of, :potential_offensive_heading
    rename_column :players, :potential_fl, :potential_flair
    rename_column :players, :potential_st, :potential_strength
    rename_column :players, :potential_cr, :potential_creativity
  end
end
