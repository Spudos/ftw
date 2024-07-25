class RemoveDateCompletedFromTurns < ActiveRecord::Migration[7.0]
  def change
    remove_column :turns, :date_completed, :date
  end
end
