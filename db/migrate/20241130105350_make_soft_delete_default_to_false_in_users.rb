class MakeSoftDeleteDefaultToFalseInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :soft_delete, from: nil, to: false
  end
end
