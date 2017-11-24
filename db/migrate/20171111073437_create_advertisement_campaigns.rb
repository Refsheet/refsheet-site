class CreateAdvertisementCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisement_campaigns do |t|
      t.integer :user_id
      t.string :title
      t.string :caption
      t.string :link
      t.attachment :image
      t.monetize :amount
      t.integer :slots_filled
      t.string :guid
      t.string :status
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :recurring
      t.integer :total_impressions
      t.integer :total_clicks

      t.timestamps
    end

    add_index :advertisement_campaigns, :guid
    add_index :advertisement_campaigns, :user_id
  end
end
