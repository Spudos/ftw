class AddColumnsToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :article_headline, :string
    add_column :turnsheets, :article_sub_headline, :string
    add_column :turnsheets, :article, :string
  end
end
