class AddActionIdToUpgrades < ActiveRecord::Migration[7.0]
  def change
    add_column :upgrades, :action_id, :string
  end
end
