class AddEventToCommentaries < ActiveRecord::Migration[7.0]
  def change
    add_column :commentaries, :event, :string
  end
end
