class RenameColumnPlayersCorr < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :creatvitiy, :creativity
  end
end
