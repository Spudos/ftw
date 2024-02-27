class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.integer :week
      t.integer :club_id
      t.string :image
      t.string :article_type
      t.string :headline
      t.string :sub_headline
      t.string :article

      t.timestamps
    end
  end
end
