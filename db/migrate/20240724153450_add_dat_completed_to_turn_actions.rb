class AddDatCompletedToTurnActions < ActiveRecord::Migration[7.0]
  def change
    add_column :turn_actions, :date_completed, :date
  end
end
