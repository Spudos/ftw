class ChangeRerePitchColumnTypeInClubs < ActiveRecord::Migration[7.0]
  def change
    change_column :clubs, :pitch, :integer
  end
end
