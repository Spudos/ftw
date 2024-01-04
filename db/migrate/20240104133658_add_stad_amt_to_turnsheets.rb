class AddStadAmtToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :stad_amt, :integer
  end
end
