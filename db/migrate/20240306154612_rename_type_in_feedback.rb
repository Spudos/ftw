class RenameTypeInFeedback < ActiveRecord::Migration[7.0]
  def change
    rename_column :feedbacks, :type, :feedback_type
  end
end
