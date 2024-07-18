class RenameProcessMessageTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :process_message, :processing
  end
end
