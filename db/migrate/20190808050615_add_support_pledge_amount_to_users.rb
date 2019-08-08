class AddSupportPledgeAmountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :support_pledge_amount, :integer, default: 0
  end
end
