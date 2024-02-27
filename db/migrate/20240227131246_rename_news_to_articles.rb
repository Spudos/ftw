class RenameNewsToArticles < ActiveRecord::Migration[7.0]
  def change
    def change
      rename_table :news, :articles
    end
  end
end
