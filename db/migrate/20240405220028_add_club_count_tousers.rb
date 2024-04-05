class AddClubCountTousers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :club_count, :integer, default: 0
  end
end
