class AddValToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :val, :integer
  end
end
