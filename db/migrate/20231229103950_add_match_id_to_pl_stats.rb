class AddMatchIdToPlstatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_statistics, :id, :integer
  end
end
