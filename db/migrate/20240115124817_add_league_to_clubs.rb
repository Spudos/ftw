class AddLeagueToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :league, :string
  end
end
