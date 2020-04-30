# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_23_210313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "user_id"
    t.integer "character_id"
    t.string "activity_type"
    t.integer "activity_id"
    t.string "activity_method"
    t.string "activity_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.integer "reply_to_activity_id"
    t.index ["activity_type"], name: "index_activities_on_activity_type"
    t.index ["character_id"], name: "index_activities_on_character_id"
    t.index ["reply_to_activity_id"], name: "index_activities_on_reply_to_activity_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "advertisement_campaigns", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "caption"
    t.string "link"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "slots_filled", default: 0
    t.string "guid"
    t.string "status"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean "recurring", default: false
    t.integer "total_impressions", default: 0
    t.integer "total_clicks", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "slots_requested", default: 0
    t.index ["ends_at"], name: "index_advertisement_campaigns_on_ends_at"
    t.index ["guid"], name: "index_advertisement_campaigns_on_guid"
    t.index ["starts_at"], name: "index_advertisement_campaigns_on_starts_at"
    t.index ["user_id"], name: "index_advertisement_campaigns_on_user_id"
  end

  create_table "advertisement_slots", id: :serial, force: :cascade do |t|
    t.integer "active_campaign_id"
    t.integer "reserved_campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_impression_at"
    t.index ["active_campaign_id"], name: "index_advertisement_slots_on_active_campaign_id"
    t.index ["last_impression_at"], name: "index_advertisement_slots_on_last_impression_at"
    t.index ["reserved_campaign_id"], name: "index_advertisement_slots_on_reserved_campaign_id"
  end

  create_table "ahoy_events", id: :serial, force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name"
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name"
  end

  create_table "ahoy_visits", id: :serial, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.integer "screen_height"
    t.integer "screen_width"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "postal_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id"
    t.string "guid"
    t.string "secret_digest"
    t.boolean "read_only", default: false
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_api_keys_on_deleted_at"
    t.index ["guid"], name: "index_api_keys_on_guid"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "artists", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.string "name"
    t.string "slug"
    t.string "commission_url"
    t.string "website_url"
    t.text "profile"
    t.text "profile_markdown"
    t.text "commission_info"
    t.text "commission_info_markdown"
    t.boolean "locked"
    t.integer "media_count"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_artists_on_lower_name"
    t.index "lower((slug)::text) varchar_pattern_ops", name: "index_artists_on_lower_slug"
    t.index ["guid"], name: "index_artists_on_guid"
    t.index ["user_id"], name: "index_artists_on_user_id"
  end

  create_table "artists_edits", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "user_id"
    t.string "summary"
    t.text "changes"
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_artists_edits_on_approved_by_id"
    t.index ["guid"], name: "index_artists_edits_on_guid"
    t.index ["user_id"], name: "index_artists_edits_on_user_id"
  end

  create_table "artists_links", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "artist_id"
    t.string "url"
    t.integer "submitted_by_id"
    t.integer "approved_by_id"
    t.datetime "approved_at"
    t.string "favicon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_artists_links_on_approved_by_id"
    t.index ["artist_id"], name: "index_artists_links_on_artist_id"
    t.index ["guid"], name: "index_artists_links_on_guid"
    t.index ["submitted_by_id"], name: "index_artists_links_on_submitted_by_id"
  end

  create_table "artists_reviews", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "artist_id"
    t.integer "user_id"
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artists_reviews_on_artist_id"
    t.index ["guid"], name: "index_artists_reviews_on_guid"
    t.index ["user_id"], name: "index_artists_reviews_on_user_id"
  end

  create_table "auctions", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.integer "slot_id"
    t.integer "starting_bid_cents", default: 0, null: false
    t.string "starting_bid_currency", default: "USD", null: false
    t.integer "minimum_increase_cents", default: 0, null: false
    t.string "minimum_increase_currency", default: "USD", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ends_at"], name: "index_auctions_on_ends_at"
    t.index ["starts_at"], name: "index_auctions_on_starts_at"
  end

  create_table "bank_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "account_holder_name"
    t.string "account_holder_type"
    t.string "bank_name"
    t.string "account_last_4"
    t.string "country", default: "US"
    t.string "currency", default: "USD"
    t.string "status"
    t.string "processor_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_bank_accounts_on_type"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "bids", id: :serial, force: :cascade do |t|
    t.integer "auction_id"
    t.integer "user_id"
    t.integer "invitation_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_bids_on_auction_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "blocked_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "blocked_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_user_id"], name: "index_blocked_users_on_blocked_user_id"
    t.index ["user_id"], name: "index_blocked_users_on_user_id"
  end

  create_table "changelogs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "changed_character_id"
    t.integer "changed_user_id"
    t.integer "changed_image_id"
    t.integer "changed_swatch_id"
    t.text "reason"
    t.json "change_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_changelogs_on_user_id"
  end

  create_table "character_groups", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "slug"
    t.integer "row_order"
    t.boolean "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "characters_count", default: 0, null: false
    t.integer "visible_characters_count", default: 0, null: false
    t.integer "hidden_characters_count", default: 0, null: false
    t.index ["hidden"], name: "index_character_groups_on_hidden"
    t.index ["row_order"], name: "index_character_groups_on_row_order"
    t.index ["slug"], name: "index_character_groups_on_slug"
    t.index ["user_id"], name: "index_character_groups_on_user_id"
  end

  create_table "character_groups_characters", id: false, force: :cascade do |t|
    t.integer "character_group_id"
    t.integer "character_id"
    t.index ["character_group_id"], name: "index_character_groups_characters_on_character_group_id"
    t.index ["character_id"], name: "index_character_groups_characters_on_character_id"
  end

  create_table "characters", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "slug"
    t.string "shortcode"
    t.text "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "species"
    t.string "height"
    t.string "weight"
    t.string "body_type"
    t.string "personality"
    t.text "special_notes"
    t.integer "featured_image_id"
    t.integer "profile_image_id"
    t.text "likes"
    t.text "dislikes"
    t.integer "color_scheme_id"
    t.boolean "nsfw"
    t.boolean "hidden", default: false
    t.boolean "secret"
    t.integer "row_order"
    t.datetime "deleted_at"
    t.text "custom_attributes"
    t.integer "version", default: 1
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_characters_on_lower_name"
    t.index "lower((shortcode)::text)", name: "index_characters_on_lower_shortcode"
    t.index "lower((slug)::text) varchar_pattern_ops", name: "index_characters_on_lower_slug"
    t.index ["deleted_at"], name: "index_characters_on_deleted_at"
    t.index ["hidden"], name: "index_characters_on_hidden"
    t.index ["secret"], name: "index_characters_on_secret"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "characters_profile_sections", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "character_id"
    t.integer "row_order"
    t.string "title"
    t.string "column_widths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["character_id"], name: "index_characters_profile_sections_on_character_id"
    t.index ["deleted_at"], name: "index_characters_profile_sections_on_deleted_at"
    t.index ["guid"], name: "index_characters_profile_sections_on_guid"
    t.index ["row_order"], name: "index_characters_profile_sections_on_row_order"
  end

  create_table "characters_profile_widgets", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.integer "character_id"
    t.integer "profile_section_id"
    t.integer "column"
    t.integer "row_order"
    t.string "widget_type"
    t.string "title"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["character_id"], name: "index_characters_profile_widgets_on_character_id"
    t.index ["deleted_at"], name: "index_characters_profile_widgets_on_deleted_at"
    t.index ["guid"], name: "index_characters_profile_widgets_on_guid"
    t.index ["profile_section_id"], name: "index_characters_profile_widgets_on_profile_section_id"
    t.index ["row_order"], name: "index_characters_profile_widgets_on_row_order"
  end

  create_table "color_schemes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.text "color_data"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_color_schemes_on_guid"
    t.index ["user_id"], name: "index_color_schemes_on_user_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.boolean "approved"
    t.string "subject"
    t.boolean "muted"
    t.string "guid"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_conversations_on_guid"
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "conversations_messages", id: :serial, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "user_id"
    t.text "message"
    t.integer "reply_to_id"
    t.datetime "read_at"
    t.datetime "deleted_at"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversations_messages_on_conversation_id"
    t.index ["guid"], name: "index_conversations_messages_on_guid"
    t.index ["reply_to_id"], name: "index_conversations_messages_on_reply_to_id"
    t.index ["user_id"], name: "index_conversations_messages_on_user_id"
  end

  create_table "conversations_read_bookmarks", id: :serial, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "message_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversations_read_bookmarks_on_conversation_id"
    t.index ["message_id"], name: "index_conversations_read_bookmarks_on_message_id"
    t.index ["user_id"], name: "index_conversations_read_bookmarks_on_user_id"
  end

  create_table "custom_watermarks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "images_count"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "gravity"
    t.integer "opacity"
    t.boolean "repeat_x"
    t.boolean "repeat_y"
    t.string "guid"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_custom_watermarks_on_guid"
    t.index ["user_id"], name: "index_custom_watermarks_on_user_id"
  end

  create_table "feedback_replies", id: :serial, force: :cascade do |t|
    t.integer "feedback_id"
    t.integer "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "freshdesk_id"
    t.index ["feedback_id"], name: "index_feedback_replies_on_feedback_id"
    t.index ["user_id"], name: "index_feedback_replies_on_user_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "email"
    t.text "comment"
    t.string "trello_card_id"
    t.string "source_url"
    t.integer "visit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "done"
    t.string "freshdesk_id"
  end

  create_table "forum_karmas", id: :serial, force: :cascade do |t|
    t.integer "karmic_id"
    t.string "karmic_type"
    t.integer "user_id"
    t.boolean "discord"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1
    t.index ["karmic_id"], name: "index_forum_karmas_on_karmic_id"
    t.index ["karmic_type"], name: "index_forum_karmas_on_karmic_type"
  end

  create_table "forum_posts", id: :serial, force: :cascade do |t|
    t.integer "thread_id"
    t.integer "user_id"
    t.integer "character_id"
    t.integer "parent_post_id"
    t.string "guid"
    t.text "content"
    t.integer "karma_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_html"
    t.boolean "admin_post", default: false
    t.boolean "moderator_post", default: false
    t.datetime "deleted_at"
    t.boolean "edited", default: false
    t.index ["character_id"], name: "index_forum_posts_on_character_id"
    t.index ["deleted_at"], name: "index_forum_posts_on_deleted_at"
    t.index ["guid"], name: "index_forum_posts_on_guid"
    t.index ["parent_post_id"], name: "index_forum_posts_on_parent_post_id"
    t.index ["thread_id"], name: "index_forum_posts_on_thread_id"
    t.index ["user_id"], name: "index_forum_posts_on_user_id"
  end

  create_table "forum_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "discussion_id"
    t.integer "user_id"
    t.datetime "last_read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "index_forum_subscriptions_on_discussion_id"
    t.index ["user_id"], name: "index_forum_subscriptions_on_user_id"
  end

  create_table "forum_threads", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.integer "character_id"
    t.string "topic"
    t.string "slug"
    t.string "shortcode"
    t.text "content"
    t.boolean "locked"
    t.integer "karma_total", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_html"
    t.boolean "sticky"
    t.boolean "admin_post"
    t.boolean "moderator_post"
    t.integer "posts_count", default: 0, null: false
    t.index "lower((shortcode)::text)", name: "index_forum_threads_on_lower_shortcode"
    t.index "lower((slug)::text) varchar_pattern_ops", name: "index_forum_threads_on_lower_slug"
    t.index ["character_id"], name: "index_forum_threads_on_character_id"
    t.index ["forum_id"], name: "index_forum_threads_on_forum_id"
    t.index ["karma_total"], name: "index_forum_threads_on_karma_total"
    t.index ["sticky"], name: "index_forum_threads_on_sticky"
    t.index ["user_id"], name: "index_forum_threads_on_user_id"
  end

  create_table "forums", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.boolean "locked"
    t.boolean "nsfw"
    t.boolean "no_rp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "system_owned", default: false
    t.text "rules"
    t.text "prepost_message"
    t.integer "owner_id"
    t.integer "fandom_id"
    t.boolean "open", default: false
    t.text "summary"
    t.integer "discussions_count", default: 0, null: false
    t.integer "members_count", default: 0, null: false
    t.integer "posts_count", default: 0, null: false
    t.index "lower((slug)::text) varchar_pattern_ops", name: "index_forums_on_lower_slug"
    t.index ["fandom_id"], name: "index_forums_on_fandom_id"
    t.index ["owner_id"], name: "index_forums_on_owner_id"
    t.index ["system_owned"], name: "index_forums_on_system_owned"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.integer "character_id"
    t.integer "artist_id"
    t.string "caption"
    t.string "source_url"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row_order"
    t.string "guid"
    t.string "gravity"
    t.boolean "nsfw"
    t.boolean "hidden", default: false
    t.integer "gallery_id"
    t.datetime "deleted_at"
    t.string "title"
    t.string "background_color"
    t.integer "comments_count"
    t.integer "favorites_count"
    t.text "image_meta"
    t.boolean "image_processing", default: false
    t.string "image_direct_upload_url"
    t.boolean "watermark"
    t.integer "custom_watermark_id"
    t.boolean "annotation"
    t.string "custom_annotation"
    t.bit "image_phash", limit: 64
    t.index ["character_id"], name: "index_images_on_character_id"
    t.index ["custom_watermark_id"], name: "index_images_on_custom_watermark_id"
    t.index ["deleted_at"], name: "index_images_on_deleted_at"
    t.index ["gallery_id"], name: "index_images_on_gallery_id"
    t.index ["guid"], name: "index_images_on_guid"
    t.index ["hidden"], name: "index_images_on_hidden"
    t.index ["image_processing"], name: "index_images_on_image_processing"
    t.index ["row_order"], name: "index_images_on_row_order"
  end

  create_table "images_media_hashtags", id: false, force: :cascade do |t|
    t.integer "image_id", null: false
    t.integer "media_hashtag_id", null: false
    t.index ["image_id", "media_hashtag_id"], name: "index_images_media_hashtags_on_image_id_and_media_hashtag_id"
    t.index ["media_hashtag_id", "image_id"], name: "index_images_media_hashtags_on_media_hashtag_id_and_image_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_code_digest"
    t.index "lower((email)::text) varchar_pattern_ops", name: "index_invitations_on_lower_email"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.integer "seller_user_id"
    t.integer "character_id"
    t.string "type"
    t.string "title"
    t.text "description"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.boolean "requires_character"
    t.datetime "published_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sold"
    t.integer "seller_id"
    t.index ["seller_id"], name: "index_items_on_seller_id"
    t.index ["seller_user_id"], name: "index_items_on_seller_user_id"
    t.index ["sold"], name: "index_items_on_sold"
  end

  create_table "lodestone_characters", force: :cascade do |t|
    t.bigint "active_class_job_id"
    t.text "bio"
    t.bigint "server_id"
    t.string "lodestone_id"
    t.string "name"
    t.string "nameday"
    t.datetime "remote_updated_at"
    t.string "portrait_url"
    t.bigint "race_id"
    t.string "title"
    t.boolean "title_top"
    t.string "town"
    t.string "tribe"
    t.string "diety"
    t.string "gc_name"
    t.string "gc_rank_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "character_id"
    t.index ["active_class_job_id"], name: "index_lodestone_characters_on_active_class_job_id"
    t.index ["character_id"], name: "index_lodestone_characters_on_character_id"
    t.index ["lodestone_id"], name: "index_lodestone_characters_on_lodestone_id"
    t.index ["race_id"], name: "index_lodestone_characters_on_race_id"
    t.index ["server_id"], name: "index_lodestone_characters_on_server_id"
  end

  create_table "lodestone_class_jobs", force: :cascade do |t|
    t.bigint "lodestone_character_id"
    t.string "name"
    t.string "class_abbr"
    t.string "class_icon_url"
    t.string "class_name"
    t.string "job_abbr"
    t.string "job_icon_url"
    t.string "job_name"
    t.integer "level"
    t.integer "exp_level"
    t.integer "exp_level_max"
    t.integer "exp_level_togo"
    t.boolean "specialized"
    t.boolean "job_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lodestone_character_id"], name: "index_lodestone_class_jobs_on_lodestone_character_id"
    t.index ["name"], name: "index_lodestone_class_jobs_on_name"
  end

  create_table "lodestone_races", force: :cascade do |t|
    t.string "lodestone_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_lodestone_races_on_lower_name"
    t.index ["lodestone_id"], name: "index_lodestone_races_on_lodestone_id"
  end

  create_table "lodestone_servers", force: :cascade do |t|
    t.string "lodestone_id"
    t.string "name"
    t.string "datacenter"
    t.integer "characters_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_lodestone_servers_on_lower_name"
    t.index ["lodestone_id"], name: "index_lodestone_servers_on_lodestone_id"
  end

  create_table "media_comments", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.integer "user_id"
    t.integer "reply_to_comment_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.index ["guid"], name: "index_media_comments_on_guid"
    t.index ["media_id"], name: "index_media_comments_on_media_id"
    t.index ["reply_to_comment_id"], name: "index_media_comments_on_reply_to_comment_id"
    t.index ["user_id"], name: "index_media_comments_on_user_id"
  end

  create_table "media_favorites", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id"], name: "index_media_favorites_on_media_id"
    t.index ["user_id"], name: "index_media_favorites_on_user_id"
  end

  create_table "media_hashtags", id: :serial, force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((tag)::text) varchar_pattern_ops", name: "index_media_hashtags_on_lower_tag"
  end

  create_table "media_tags", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.integer "character_id"
    t.integer "position_x"
    t.integer "position_y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_media_tags_on_character_id"
    t.index ["media_id"], name: "index_media_tags_on_media_id"
  end

  create_table "moderation_reports", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "sender_user_id"
    t.integer "moderatable_id"
    t.string "moderatable_type"
    t.string "violation_type"
    t.text "comment"
    t.string "dmca_source_url"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moderatable_id"], name: "index_moderation_reports_on_moderatable_id"
    t.index ["moderatable_type"], name: "index_moderation_reports_on_moderatable_type"
    t.index ["sender_user_id"], name: "index_moderation_reports_on_sender_user_id"
    t.index ["status"], name: "index_moderation_reports_on_status"
    t.index ["user_id"], name: "index_moderation_reports_on_user_id"
    t.index ["violation_type"], name: "index_moderation_reports_on_violation_type"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "character_id"
    t.integer "sender_user_id"
    t.integer "sender_character_id"
    t.string "type"
    t.integer "actionable_id"
    t.string "actionable_type"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.index ["character_id"], name: "index_notifications_on_character_id"
    t.index ["guid"], name: "index_notifications_on_guid"
    t.index ["type"], name: "index_notifications_on_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
    t.integer "slot_id"
    t.integer "auction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_cents"
    t.string "amount_currency", default: "USD"
    t.integer "processor_fee_cents"
    t.integer "marketplace_fee_cents"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "organization_memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_organization_memberships_on_admin"
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
    t.index ["user_id"], name: "index_organization_memberships_on_user_id"
  end

  create_table "patreon_patrons", id: :serial, force: :cascade do |t|
    t.string "patreon_id"
    t.string "email"
    t.string "full_name"
    t.string "image_url"
    t.boolean "is_deleted"
    t.boolean "is_nuked"
    t.boolean "is_suspended"
    t.string "status"
    t.string "thumb_url"
    t.string "twitch"
    t.string "twitter"
    t.string "youtube"
    t.string "vanity"
    t.string "url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_code_digest"
    t.integer "pending_user_id"
    t.index "lower((email)::text) varchar_pattern_ops", name: "index_patreon_patrons_on_lower_email"
    t.index ["patreon_id"], name: "index_patreon_patrons_on_patreon_id"
    t.index ["pending_user_id"], name: "index_patreon_patrons_on_pending_user_id"
    t.index ["status"], name: "index_patreon_patrons_on_status"
    t.index ["user_id"], name: "index_patreon_patrons_on_user_id"
  end

  create_table "patreon_pledges", id: :serial, force: :cascade do |t|
    t.string "patreon_id"
    t.integer "amount_cents"
    t.datetime "declined_since"
    t.boolean "patron_pays_fees"
    t.integer "pledge_cap_cents"
    t.integer "patreon_reward_id"
    t.integer "patreon_patron_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patreon_id"], name: "index_patreon_pledges_on_patreon_id"
    t.index ["patreon_patron_id"], name: "index_patreon_pledges_on_patreon_patron_id"
  end

  create_table "patreon_rewards", id: :serial, force: :cascade do |t|
    t.string "patreon_id"
    t.integer "amount_cents"
    t.text "description"
    t.string "image_url"
    t.boolean "requires_shipping"
    t.string "title"
    t.string "url"
    t.boolean "grants_badge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patreon_id"], name: "index_patreon_rewards_on_patreon_id"
  end

  create_table "payment_transfers", id: :serial, force: :cascade do |t|
    t.integer "seller_id"
    t.integer "payment_id"
    t.integer "order_id"
    t.string "processor_id"
    t.string "type"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payment_transfers_on_order_id"
    t.index ["payment_id"], name: "index_payment_transfers_on_payment_id"
    t.index ["processor_id"], name: "index_payment_transfers_on_processor_id"
    t.index ["seller_id"], name: "index_payment_transfers_on_seller_id"
    t.index ["type"], name: "index_payment_transfers_on_type"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "processor_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "state"
    t.string "failure_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "processor_fee_cents"
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["processor_id"], name: "index_payments_on_processor_id"
    t.index ["type"], name: "index_payments_on_type"
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
    t.index ["user_id", "role_id"], name: "index_permissions_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sellers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "type"
    t.integer "address_id"
    t.string "processor_id"
    t.string "first_name"
    t.string "last_name"
    t.datetime "dob"
    t.datetime "tos_acceptance_date"
    t.string "tos_acceptance_ip"
    t.string "default_currency"
    t.string "processor_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_sellers_on_type"
    t.index ["user_id"], name: "index_sellers_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id"
  end

  create_table "slots", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.integer "extends_slot_id"
    t.string "title"
    t.text "description"
    t.string "color"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.boolean "requires_character"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "swatches", id: :serial, force: :cascade do |t|
    t.integer "character_id"
    t.string "name"
    t.string "color"
    t.text "notes"
    t.integer "row_order"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_swatches_on_character_id"
    t.index ["guid"], name: "index_swatches_on_guid"
    t.index ["row_order"], name: "index_swatches_on_row_order"
  end

  create_table "transaction_resources", id: :serial, force: :cascade do |t|
    t.integer "transaction_id"
    t.string "processor_id"
    t.string "type"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "transaction_fee_cents", default: 0, null: false
    t.string "transaction_fee_currency", default: "USD", null: false
    t.string "payment_mode"
    t.string "status"
    t.string "reason_code"
    t.datetime "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.integer "payment_id"
    t.string "processor_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "character_id"
    t.integer "item_id"
    t.integer "sender_user_id"
    t.integer "destination_user_id"
    t.integer "invitation_id"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "rejected_at"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.index ["character_id"], name: "index_transfers_on_character_id"
    t.index ["destination_user_id"], name: "index_transfers_on_destination_user_id"
    t.index ["guid"], name: "index_transfers_on_guid"
    t.index ["item_id"], name: "index_transfers_on_item_id"
    t.index ["sender_user_id"], name: "index_transfers_on_sender_user_id"
    t.index ["status"], name: "index_transfers_on_status"
  end

  create_table "user_followers", id: :serial, force: :cascade do |t|
    t.integer "following_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_user_followers_on_follower_id"
    t.index ["following_id"], name: "index_user_followers_on_following_id"
  end

  create_table "user_sessions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "ahoy_visit_id"
    t.string "session_guid"
    t.string "session_token_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ahoy_visit_id"], name: "index_user_sessions_on_ahoy_visit_id"
    t.index ["session_guid"], name: "index_user_sessions_on_session_guid"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.text "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.json "settings"
    t.string "type"
    t.string "auth_code_digest"
    t.integer "parent_user_id"
    t.string "unconfirmed_email"
    t.datetime "email_confirmed_at"
    t.datetime "deleted_at"
    t.boolean "avatar_processing"
    t.integer "support_pledge_amount", default: 0
    t.string "guid"
    t.boolean "admin"
    t.boolean "patron"
    t.boolean "supporter"
    t.boolean "moderator"
    t.index "lower((email)::text) varchar_pattern_ops", name: "index_users_on_lower_email"
    t.index "lower((unconfirmed_email)::text) varchar_pattern_ops", name: "index_users_on_lower_unconfirmed_email"
    t.index "lower((username)::text) varchar_pattern_ops", name: "index_users_on_lower_username"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["guid"], name: "index_users_on_guid"
    t.index ["parent_user_id"], name: "index_users_on_parent_user_id"
    t.index ["type"], name: "index_users_on_type"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.datetime "created_at"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "activities", column: "reply_to_activity_id"
  add_foreign_key "api_keys", "users"
  add_foreign_key "artists_edits", "users"
  add_foreign_key "artists_edits", "users", column: "approved_by_id"
  add_foreign_key "artists_links", "artists"
  add_foreign_key "artists_links", "users", column: "approved_by_id"
  add_foreign_key "artists_links", "users", column: "submitted_by_id"
  add_foreign_key "artists_reviews", "artists"
  add_foreign_key "artists_reviews", "users"
  add_foreign_key "blocked_users", "users"
  add_foreign_key "blocked_users", "users", column: "blocked_user_id"
  add_foreign_key "characters_profile_widgets", "characters"
  add_foreign_key "characters_profile_widgets", "characters_profile_sections", column: "profile_section_id"
  add_foreign_key "conversations_read_bookmarks", "conversations"
  add_foreign_key "conversations_read_bookmarks", "conversations_messages", column: "message_id"
  add_foreign_key "conversations_read_bookmarks", "users"
  add_foreign_key "images", "custom_watermarks"
  add_foreign_key "lodestone_characters", "characters"
  add_foreign_key "media_tags", "characters"
  add_foreign_key "media_tags", "images", column: "media_id"
  add_foreign_key "user_sessions", "ahoy_visits"
  add_foreign_key "user_sessions", "users"
end
