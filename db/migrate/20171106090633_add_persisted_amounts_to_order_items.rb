class AddPersistedAmountsToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :amount_cents, :integer
    add_column :order_items, :amount_currency, :string, default: 'USD'
    add_column :order_items, :processor_fee_cents, :integer
    add_column :order_items, :marketplace_fee_cents, :integer
  end
end
