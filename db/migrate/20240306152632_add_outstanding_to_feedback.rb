class AddOutstandingToFeedback < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :type, :string
    add_column :feedbacks, :outstanding, :boolean
  end
end
