class AddAggressionToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :def_aggression, :integer
    add_column :turnsheets, :mid_aggression, :integer
    add_column :turnsheets, :att_aggression, :integer
  end
end
