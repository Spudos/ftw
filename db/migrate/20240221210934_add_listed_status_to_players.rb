class AddListedStatusToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :listed, :boolean
  end
end
