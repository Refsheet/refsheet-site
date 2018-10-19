class CreateSellers < ActiveRecord::Migration[5.0]
  def change
    create_table :sellers do |t|
      t.integer :user_id
      t.string :type
      t.integer :address_id
      t.string :processor_id
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.datetime :tos_acceptance_date
      t.string :tos_acceptance_ip
      t.string :default_currency
      t.string :processor_type

      t.timestamps
    end

    add_index :sellers, :user_id
    add_index :sellers, :type
  end
end
