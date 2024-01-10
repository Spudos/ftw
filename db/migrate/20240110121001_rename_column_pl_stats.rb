class RenameColumnPlStats < ActiveRecord::Migration[7.0]
  def change
    rename_column :pl_stats, :motm, :man_of_the_match
  end
end
