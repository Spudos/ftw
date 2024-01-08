class CreateTemplate < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :commentary_type
      t.string :text

      t.timestamps
    end
  end
end
