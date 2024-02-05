class AddConstraintsToTacticsField < ActiveRecord::Migration[7.0]
  def change
    Tactic.where(tactics: nil).update_all(press: 0)

    change_column :tactics, :tactics, :integer, null: false, default: 0
  end
end
