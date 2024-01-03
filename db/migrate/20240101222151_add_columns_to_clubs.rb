class AddColumnsToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :ground_name, :string
    add_column :clubs, :stand_n_name, :string
    add_column :clubs, :stand_n_condition, :integer
    add_column :clubs, :stand_n_capacity, :integer
    add_column :clubs, :stand_s_name, :string
    add_column :clubs, :stand_s_condition, :integer
    add_column :clubs, :stand_s_capacity, :integer
    add_column :clubs, :stand_e_name, :string
    add_column :clubs, :stand_e_condition, :integer
    add_column :clubs, :stand_e_capacity, :integer
    add_column :clubs, :stand_w_name, :string
    add_column :clubs, :stand_w_condition, :integer
    add_column :clubs, :stand_w_capacity, :integer
    add_column :clubs, :pitch, :string
    add_column :clubs, :hospitality, :integer
    add_column :clubs, :facilities, :integer
    add_column :clubs, :staff_fitness, :integer
    add_column :clubs, :staff_gkp, :integer
    add_column :clubs, :staff_dfc, :integer
    add_column :clubs, :staff_mid, :integer
    add_column :clubs, :staff_att, :integer
    add_column :clubs, :staff_scouts, :integer
    add_column :clubs, :color_primary, :string
    add_column :clubs, :color_secondary, :string
  end
end
