class RenameProcessMessagesTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :process_messages, :process_message
  end
end
