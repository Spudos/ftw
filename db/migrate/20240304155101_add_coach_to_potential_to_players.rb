class AddCoachToPotentialToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :potential_passing_coached, :boolean, default: false
    add_column :players, :potential_control_coached, :boolean, default: false
    add_column :players, :potential_tackling_coached, :boolean, default: false
    add_column :players, :potential_running_coached, :boolean, default: false
    add_column :players, :potential_shooting_coached, :boolean, default: false
    add_column :players, :potential_dribbling_coached, :boolean, default: false
    add_column :players, :potential_defensive_heading_coached, :boolean, default: false
    add_column :players, :potential_offensive_heading_coached, :boolean, default: false
    add_column :players, :potential_flair_coached, :boolean, default: false
    add_column :players, :potential_strength_coached, :boolean, default: false
    add_column :players, :potential_creativity_coached, :boolean, default: false
  end
end
