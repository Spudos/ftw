class AddStatusToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :status, :string
  end
end
