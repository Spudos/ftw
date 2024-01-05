class AddManagerToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :managed, :boolean
    add_column :clubs, :manager, :string
    add_column :clubs, :manager_email, :string
  end
end
