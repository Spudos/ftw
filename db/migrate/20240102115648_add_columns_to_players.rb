class AddColumnsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :pot_pa, :integer
    add_column :players, :pot_co, :integer
    add_column :players, :pot_ta, :integer
    add_column :players, :pot_ru, :integer
    add_column :players, :pot_sh, :integer
    add_column :players, :pot_dr, :integer
    add_column :players, :pot_df, :integer
    add_column :players, :pot_of, :integer
    add_column :players, :pot_fl, :integer
    add_column :players, :pot_st, :integer
    add_column :players, :pot_cr, :integer
  end
end
