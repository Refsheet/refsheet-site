class CreateMediaArtistCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :media_artist_credits do |t|
      t.belongs_to :media, foreign_key: { to_table: :images }
      t.belongs_to :artist, foreign_key: true
      t.boolean :validated
      t.belongs_to :validated_by_user, foreign_key: { to_table: :users }
      t.belongs_to :tagged_by_user, foreign_key: { to_table: :users }
      t.text :notes
      t.datetime :validated_at

      t.timestamps
    end
  end
end
