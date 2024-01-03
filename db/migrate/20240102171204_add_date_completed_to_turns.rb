class AddDateCompletedToTurns < ActiveRecord::Migration[7.0]
  def change
    add_column :turns, :date_completed, :date
  end
end
