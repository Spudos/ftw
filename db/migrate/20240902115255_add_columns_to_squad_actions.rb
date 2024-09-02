class AddColumnsToSquadActions < ActiveRecord::Migration[7.0]
  def change
    add_column :squad_actions, :week, :integer
    add_column :squad_actions, :processed, :boolean, default: false
  end
end
