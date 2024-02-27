class DropNews < ActiveRecord::Migration[7.0]
  def change
    drop_table :news
  end
end
