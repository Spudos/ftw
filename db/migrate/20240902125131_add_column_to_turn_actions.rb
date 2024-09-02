class AddColumnToTurnActions < ActiveRecord::Migration[7.0]
  def change
    add_column :turns, :squad_actions, :boolean
  end
end
