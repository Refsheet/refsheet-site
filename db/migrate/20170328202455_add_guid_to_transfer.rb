class AddGuidToTransfer < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :guid, :string
    add_index :transfers, :guid
  end
end
