class AddPressToTurnsheet < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :press, :integer
  end
end
