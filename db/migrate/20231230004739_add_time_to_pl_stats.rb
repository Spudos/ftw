class AddTimeToPlStats < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_stats, :time, :integer
  end
end
