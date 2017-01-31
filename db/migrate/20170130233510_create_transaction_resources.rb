class CreateTransactionResources < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_resources do |t|
      t.integer :transaction_id
      t.string :processor_id
      t.string :type
      t.monetize :amount
      t.monetize :transaction_fee
      t.string :payment_mode
      t.string :status
      t.string :reason_code
      t.datetime :valid_until

      t.timestamps
    end
  end
end
