class AddPressToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :home_press, :integer
    add_column :matches, :away_press, :integer
  end
end
