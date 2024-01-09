class AddScoreToCommentaries < ActiveRecord::Migration[7.0]
  def change
    add_column :commentaries, :home_score, :integer
    add_column :commentaries, :away_score, :integer
  end
end
