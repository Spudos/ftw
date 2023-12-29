class AddMatchIdToPlStats < ActiveRecord::Migration[7.0]
  def change
    add_column :pl_stats, :match_id, :integer
  end
end
