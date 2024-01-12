class DropPlStats1 < ActiveRecord::Migration[7.0]
  def change
    drop_table :pl_stats
  end
end
