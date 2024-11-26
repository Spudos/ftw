class AddWaitingListToGameParams < ActiveRecord::Migration[7.0]
  def change
    add_column :game_params, :waiting_list, :boolean, default: false
  end
end
