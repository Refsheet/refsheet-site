class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :seller_user_id
      t.integer :character_id
      t.string :type
      t.string :title
      t.text :description
      t.monetize :amount
      t.boolean :requires_character
      t.datetime :published_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
