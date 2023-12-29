class RemoveGoalsAndAssistsFromPlStats < ActiveRecord::Migration[7.0]
  def change
    remove_column :pl_stats, :goals, :integer
    remove_column :pl_stats, :assists, :integer
  end
end
