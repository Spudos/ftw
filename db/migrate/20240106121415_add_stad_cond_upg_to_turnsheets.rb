class AddStadCondUpgToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :stad_cond_upg, :string
  end
end
