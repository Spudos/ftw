class AddWeekNumberToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :week_number, :integer
  end
end
