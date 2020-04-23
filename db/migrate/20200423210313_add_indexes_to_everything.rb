class AddIndexesToEverything < ActiveRecord::Migration[6.0]
  def change
    # Ads
    add_index :advertisement_campaigns, :starts_at
    add_index :advertisement_campaigns, :ends_at
    add_index :advertisement_slots, :last_impression_at

    # Other Dates for Boolean operations
    add_index :auctions, :starts_at
    add_index :auctions, :ends_at
    add_index :bids, :auction_id
    add_index :bids, :user_id

    add_index :changelogs, :user_id

    add_index :character_groups, :hidden
    add_index :character_groups, :row_order

    # Paranoia (deleted_at)
    add_index :api_keys, :deleted_at

    # GUIDs
    add_index :artists_links, :guid
    add_index :color_schemes, :guid
    add_index :color_schemes, :user_id

    # Slugs
    remove_index :artists, :slug
    add_index :artists, 'LOWER(artists.slug) varchar_pattern_ops',
              name: 'index_artists_on_lower_slug',
              unique: true

    add_index :characters, :user_id
    add_index :characters, 'LOWER(characters.slug) varchar_pattern_ops',
              name: 'index_characters_on_lower_slug',
              unique: true

    add_index :characters, 'LOWER(characters.shortcode)',
              name: 'index_characters_on_lower_shortcode',
              unique: true

    add_index :characters, :deleted_at
    add_index :characters, :hidden
    add_index :characters, :secret

    remove_index :forum_threads, :shortcode
    add_index :forum_threads, 'LOWER(forum_threads.shortcode)',
              name: 'index_forum_threads_on_lower_shortcode',
              unique: true

    remove_index :forum_threads, :slug
    add_index :forum_threads, 'LOWER(forum_threads.slug) varchar_pattern_ops',
              name: 'index_forum_threads_on_lower_slug',
              unique: true

    remove_index :forums, :slug
    add_index :forums, 'LOWER(forums.slug) varchar_pattern_ops',
              name: 'index_forums_on_lower_slug',
              unique: true

    # Search Things
    add_index :artists, 'LOWER(artists.name) varchar_pattern_ops',
              name: 'index_artists_on_lower_name'

    add_index :characters, 'LOWER(characters.name) varchar_pattern_ops',
              name: 'index_characters_on_lower_name'

    add_index :images, :hidden
    add_index :images, :deleted_at
    add_index :images, :gallery_id
    add_index :images, :character_id
    add_index :images, :row_order
    add_index :images, :image_processing

    add_index :invitations, 'LOWER(invitations.email) varchar_pattern_ops',
              name: 'index_invitations_on_lower_email'

    add_index :items, :seller_user_id
    add_index :items, :seller_id

    add_index :lodestone_servers, 'LOWER(lodestone_servers.name) varchar_pattern_ops',
              name: 'index_lodestone_servers_on_lower_name'

    add_index :lodestone_races, 'LOWER(lodestone_races.name) varchar_pattern_ops',
              name: 'index_lodestone_races_on_lower_name'

    add_index :media_hashtags, 'LOWER(media_hashtags.tag) varchar_pattern_ops',
              name: 'index_media_hashtags_on_lower_tag'

    add_index :patreon_patrons, :patreon_id
    add_index :patreon_patrons, 'LOWER(patreon_patrons.email) varchar_pattern_ops',
              name: 'index_patreon_patrons_on_lower_email'
    add_index :patreon_patrons, :user_id
    add_index :patreon_patrons, :pending_user_id
    add_index :patreon_patrons, :status

    add_index :patreon_pledges, :patreon_id
    add_index :patreon_pledges, :patreon_patron_id

    add_index :patreon_rewards, :patreon_id

    add_index :payments, :order_id
    add_index :payments, :processor_id

    add_index :payment_transfers, :processor_id

    add_index :permissions, :user_id
    add_index :permissions, :role_id
    add_index :permissions, [:user_id, :role_id]

    add_index :roles, :name

    add_index :swatches, :character_id
    add_index :swatches, :row_order
    add_index :swatches, :guid

    add_index :transfers, :character_id
    add_index :transfers, :item_id
    add_index :transfers, :sender_user_id
    add_index :transfers, :destination_user_id
    add_index :transfers, :status

    add_index :users, 'LOWER(users.username) varchar_pattern_ops',
              name: 'index_users_on_lower_username',
              unique: true

    add_index :users, 'LOWER(users.email) varchar_pattern_ops',
              name: 'index_users_on_lower_email',
              unique: true

    add_index :users, 'LOWER(users.unconfirmed_email) varchar_pattern_ops',
              name: 'index_users_on_lower_unconfirmed_email'
  end
end
