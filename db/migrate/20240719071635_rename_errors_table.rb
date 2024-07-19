class RenameErrorsTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :errors_tables, :errors
  end
end
