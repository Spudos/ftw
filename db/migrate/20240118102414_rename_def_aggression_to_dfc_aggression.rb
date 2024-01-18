class RenameDefAggressionToDfcAggression < ActiveRecord::Migration[7.0]
  def change
    rename_column :turnsheets, :def_aggression, :dfc_aggression
  end
end
