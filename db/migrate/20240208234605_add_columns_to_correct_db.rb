class AddColumnsToCorrectDb < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :transfer_type, :string

    remove_column :transfers, :transfer_type
  end
end
