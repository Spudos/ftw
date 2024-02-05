class AddConstraintsToTactics < ActiveRecord::Migration[7.0]
  def change
    Tactic.where(dfc_aggression: nil).update_all(dfc_aggression: 0)
    Tactic.where(mid_aggression: nil).update_all(mid_aggression: 0)
    Tactic.where(att_aggression: nil).update_all(att_aggression: 0)
    Tactic.where(press: nil).update_all(press: 0)

    change_column :tactics, :dfc_aggression, :integer, null: false, default: 0
    change_column :tactics, :mid_aggression, :integer, null: false, default: 0
    change_column :tactics, :att_aggression, :integer, null: false, default: 0
    change_column :tactics, :press, :integer, null: false, default: 0
  end
end
