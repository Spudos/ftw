class AddAggressionToTactics < ActiveRecord::Migration[7.0]
  def change
    add_column :tactics, :dfc_aggression, :integer
    add_column :tactics, :mid_aggression, :integer
    add_column :tactics, :att_aggression, :integer
  end
end
