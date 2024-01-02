class AddActionIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :action_id, :string
  end
end
