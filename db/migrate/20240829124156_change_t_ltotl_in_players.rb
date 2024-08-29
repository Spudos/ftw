class ChangeTLtotlInPlayers < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :TL, :tl
    change_column_default :players, :tl, 0
  end
end
