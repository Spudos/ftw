class RenameColumnHmTeam < ActiveRecord::Migration[7.0]
  def change
      rename_column :matches, :home_cha, :home_chance
      rename_column :matches, :away_cha, :away_chance
  end
end
