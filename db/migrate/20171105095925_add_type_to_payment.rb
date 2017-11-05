class AddTypeToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :type, :string
    add_index :payments, :type
  end
end
