class RenameTypeInErrors < ActiveRecord::Migration[7.0]
  def change
    rename_column :errors, :type, :error_type
  end
end
