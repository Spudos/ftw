class ChangeColumnNameInNewsCorrect < ActiveRecord::Migration[7.0]
  def change
    rename_column :news, :type, :news_type
  end
end
