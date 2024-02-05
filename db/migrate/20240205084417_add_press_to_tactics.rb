class AddPressToTactics < ActiveRecord::Migration[7.0]
  def change
    add_column :tactics, :press, :integer
  end
end
