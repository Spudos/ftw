class AddTacticToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :tactic_home, :integer
    add_column :matches, :tactic_away, :integer
  end
end
