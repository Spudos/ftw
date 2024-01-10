class AddColumnsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :potential_pa, :integer
    add_column :players, :potential_co, :integer
    add_column :players, :potential_ta, :integer
    add_column :players, :potential_ru, :integer
    add_column :players, :potential_sh, :integer
    add_column :players, :potential_dr, :integer
    add_column :players, :potential_df, :integer
    add_column :players, :potential_of, :integer
    add_column :players, :potential_fl, :integer
    add_column :players, :potential_st, :integer
    add_column :players, :potential_cr, :integer
  end
end
