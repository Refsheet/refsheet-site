class CreatePatreonPatrons < ActiveRecord::Migration[5.0]
  def change
    create_table :patreon_patrons do |t|
      t.string :patreon_id
      t.string :email
      t.string :full_name
      t.string :image_url
      t.boolean :is_deleted
      t.boolean :is_nuked
      t.boolean :is_suspended
      t.string :status
      t.string :thumb_url
      t.string :twitch
      t.string :twitter
      t.string :youtube
      t.string :vanity
      t.string :url
      t.integer :user_id

      t.timestamps
    end
  end
end
