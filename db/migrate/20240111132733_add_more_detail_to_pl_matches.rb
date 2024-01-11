class AddMoreDetailToPlMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_matches, :club, :string
    add_column :pl_matches, :player_name, :string
    add_column :pl_matches, :total_skill, :integer
  end
end
