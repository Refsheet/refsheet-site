class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.string :processor_id
      t.monetize :amount
      t.string :state
      t.string :failure_reason

      t.timestamps
    end
  end
end
