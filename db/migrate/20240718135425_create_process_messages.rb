class CreateProcessMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :process_messages do |t|
      t.string :message

      t.timestamps
    end
  end
end
