class AddDateCompletedToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :bank_bal, :integer
  end
end
