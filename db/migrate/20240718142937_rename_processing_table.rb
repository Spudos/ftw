class RenameProcessingTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :processing, :processings
  end
end
