class AddTransferOptionToTurnsheet < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :transfer_club, :string
    add_column :turnsheets, :transfer1_club, :string
    add_column :turnsheets, :transfer2_club, :string
    add_column :turnsheets, :transfer3_club, :string
  end
end
