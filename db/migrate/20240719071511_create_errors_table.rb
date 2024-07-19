class CreateErrorsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :errors_tables do |t|
      t.string :type
      t.string :message

      t.timestamps
    end
  end
end
