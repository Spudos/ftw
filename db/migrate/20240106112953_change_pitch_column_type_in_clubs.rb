class ChangePitchColumnTypeInClubs < ActiveRecord::Migration[7.0]
  def change
    def change
      change_column :clubs, :pitch, :integer
    end
  end
end
