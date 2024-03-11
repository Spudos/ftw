class RemoveColumnsNotUsed < ActiveRecord::Migration[7.0]
  def change
    remove_column :clubs, :manager_email, :string
    remove_column :clubs, :manager, :string
    remove_column :matches, :week, :integer
    remove_column :matches, :comp, :string
  end
end
