class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.integer :user_id
      t.string :account_holder_name
      t.string :account_holder_type
      t.string :bank_name
      t.string :account_last_4
      t.string :country, default: 'US'
      t.string :currency, default: 'USD'
      t.string :status
      t.string :processor_id
      t.string :type

      t.timestamps
    end

    add_index :bank_accounts, :type
    add_index :bank_accounts, :user_id
  end
end
