class AddVar3ToUpgrades < ActiveRecord::Migration[7.0]
  def change
    add_column :upgrades, :var3, :integer
  end
end
