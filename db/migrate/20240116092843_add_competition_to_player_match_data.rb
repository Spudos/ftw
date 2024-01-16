class AddCompetitionToPlayerMatchData < ActiveRecord::Migration[7.0]
  def change
    add_column :player_match_data, :competition, :string
  end
end
