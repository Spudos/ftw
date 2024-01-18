class AddBlendToMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :dfc_blend_home, :integer
    add_column :matches, :mid_blend_home, :integer
    add_column :matches, :att_blend_home, :integer
    add_column :matches, :dfc_blend_away, :integer
    add_column :matches, :mid_blend_away, :integer
    add_column :matches, :att_blend_away, :integer
  end
end
