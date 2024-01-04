class AddProcessedToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :processed, :datetime
  end
end
