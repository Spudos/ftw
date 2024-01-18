class AddAggressionToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :dfc_aggression_home, :integer
    add_column :matches, :mid_aggression_home, :integer
    add_column :matches, :att_aggression_home, :integer
    add_column :matches, :dfc_aggression_away, :integer
    add_column :matches, :mid_aggression_away, :integer
    add_column :matches, :att_aggression_away, :integer
  end
end
