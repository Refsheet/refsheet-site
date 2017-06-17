class AddRowOrderToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :row_order, :integer
  end
end
