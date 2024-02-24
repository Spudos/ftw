class AddVar3ToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :var3, :integer
  end
end
