class AddRowOrderToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :row_order, :integer
  end
end
