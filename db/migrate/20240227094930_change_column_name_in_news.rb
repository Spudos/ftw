class ChangeColumnNameInNews < ActiveRecord::Migration[7.0]
  def change
    change_column :news, :type, :news_type
  end
end
