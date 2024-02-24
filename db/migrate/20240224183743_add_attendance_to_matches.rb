class AddAttendanceToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :attendance, :integer
  end
end
