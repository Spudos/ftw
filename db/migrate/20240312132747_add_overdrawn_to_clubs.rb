class AddOverdrawnToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :overdrawn, :integer, default: 0
  end
end
