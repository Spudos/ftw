class AddCompToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :competition, :string
  end
end
