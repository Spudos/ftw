class AddMessagingToTurnsheet < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :club_message, :integer
    add_column :turnsheets, :message_text, :string
    add_column :turnsheets, :public_message, :string
  end
end
