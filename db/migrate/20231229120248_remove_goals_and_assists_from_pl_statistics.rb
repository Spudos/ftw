class RemoveGoalsAndAssistsFromPlStatistics < ActiveRecord::Migration[7.0]
  def change
    remove_column :pl_statistics, :goals, :integer
    remove_column :pl_statistics, :assists, :integer
  end
end
