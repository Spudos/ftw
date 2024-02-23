class AddVar4ToTurns < ActiveRecord::Migration[7.0]
  def change
    add_column :turns, :var4, :string
  end
end
