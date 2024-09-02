class AddForeignKeyToSquadActions < ActiveRecord::Migration[7.0]
  def change
    add_reference :squad_actions, :turnsheets, foreign_key: true
    remove_column :squad_actions, :week
    remove_column :squad_actions, :processed
    remove_column :squad_actions, :amount
  end
end
