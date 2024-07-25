class DropProcessings < ActiveRecord::Migration[7.0]
  def change
    drop_table :processings
  end
end
