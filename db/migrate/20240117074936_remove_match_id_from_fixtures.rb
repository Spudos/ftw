class RemoveMatchIdFromFixtures < ActiveRecord::Migration[7.0]
  def change
    remove_column :fixtures, :match_id, :integer
  end
end
