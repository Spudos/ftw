class AddPropUpgToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :prop_upg, :string
  end
end
