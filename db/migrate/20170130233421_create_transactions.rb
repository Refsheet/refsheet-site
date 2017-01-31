class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :payment_id
      t.string :processor_id
      t.monetize :amount

      t.timestamps
    end
  end
end
