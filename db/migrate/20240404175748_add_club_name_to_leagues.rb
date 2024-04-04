class AddClubNameToLeagues < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :name, :string
  end
end
