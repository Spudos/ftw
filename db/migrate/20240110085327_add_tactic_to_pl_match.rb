class AddTacticToPlMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_matches, :tactic, :integer
  end
end
