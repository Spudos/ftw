class AddFanHappinessToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :fan_happiness, :integer, default: rand(30..80)
    add_column :clubs, :fanbase, :integer, default: rand(10000..150000)
  end
end
