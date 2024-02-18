class RemoveAbbreviation < ActiveRecord::Migration[7.0]
  def change
    remove_column :clubs, :abbreviation, :string
    rename_column :messages, :club, :club_id
    rename_column :performances, :club, :club_id
    remove_column :players, :club, :string
    rename_column :selections, :club, :club_id
    rename_column :turnsheets, :club, :club_id
    rename_column :turns, :club, :club_id
    rename_column :upgrades, :club, :club_id
  end
end
