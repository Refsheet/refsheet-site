class CreatePaymentTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_transfers do |t|
      t.integer :seller_id
      t.integer :payment_id
      t.integer :order_id
      t.string :processor_id
      t.string :type
      t.monetize :amount
      t.string :status

      t.timestamps
    end

    add_index :payment_transfers, :seller_id
    add_index :payment_transfers, :payment_id
    add_index :payment_transfers, :order_id
    add_index :payment_transfers, :type
  end
end
