class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.integer :auction_id
      t.integer :user_id
      t.integer :invitation_id
      t.monetize :amount

      t.timestamps
    end
  end
end
