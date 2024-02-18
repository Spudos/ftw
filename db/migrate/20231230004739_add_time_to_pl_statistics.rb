class AddTimeToPlStatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_statistics, :time, :integer
  end
end
