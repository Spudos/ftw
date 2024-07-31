class AddSquadCorrectionToTurns < ActiveRecord::Migration[7.0]
  def change
    add_column :turns, :squad_correction, :boolean, default: false
  end
end
