# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170328202455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "auctions", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "slot_id"
    t.integer  "starting_bid_cents",        default: 0,     null: false
    t.string   "starting_bid_currency",     default: "USD", null: false
    t.integer  "minimum_increase_cents",    default: 0,     null: false
    t.string   "minimum_increase_currency", default: "USD", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "auction_id"
    t.integer  "user_id"
    t.integer  "invitation_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "changelogs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "changed_character_id"
    t.integer  "changed_user_id"
    t.integer  "changed_image_id"
    t.integer  "changed_swatch_id"
    t.text     "reason"
    t.json     "change_data"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "characters", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "slug"
    t.string   "shortcode"
    t.text     "profile"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "gender"
    t.string   "species"
    t.string   "height"
    t.string   "weight"
    t.string   "body_type"
    t.string   "personality"
    t.text     "special_notes"
    t.integer  "featured_image_id"
    t.integer  "profile_image_id"
    t.text     "likes"
    t.text     "dislikes"
    t.integer  "color_scheme_id"
    t.boolean  "nsfw"
    t.boolean  "hidden"
    t.boolean  "secret"
  end

  create_table "color_schemes", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "color_data"
    t.string   "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.string   "trello_card_id"
    t.string   "source_url"
    t.integer  "visit_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "artist_id"
    t.string   "caption"
    t.string   "source_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "row_order"
    t.string   "guid"
    t.string   "gravity"
    t.boolean  "nsfw"
    t.boolean  "hidden"
    t.integer  "gallery_id"
    t.index ["guid"], name: "index_images_on_guid", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "seller_user_id"
    t.integer  "character_id"
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "USD", null: false
    t.boolean  "requires_character"
    t.datetime "published_at"
    t.datetime "expires_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "slot_id"
    t.integer  "auction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patreon_patrons", force: :cascade do |t|
    t.string   "patreon_id"
    t.string   "email"
    t.string   "full_name"
    t.string   "image_url"
    t.boolean  "is_deleted"
    t.boolean  "is_nuked"
    t.boolean  "is_suspended"
    t.string   "status"
    t.string   "thumb_url"
    t.string   "twitch"
    t.string   "twitter"
    t.string   "youtube"
    t.string   "vanity"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "patreon_pledges", force: :cascade do |t|
    t.string   "patreon_id"
    t.integer  "amount_cents"
    t.datetime "declined_since"
    t.boolean  "patron_pays_fees"
    t.integer  "pledge_cap_cents"
    t.integer  "patreon_reward_id"
    t.integer  "patreon_patron_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "patreon_rewards", force: :cascade do |t|
    t.string   "patreon_id"
    t.integer  "amount_cents"
    t.text     "description"
    t.string   "image_url"
    t.boolean  "requires_shipping"
    t.string   "title"
    t.string   "url"
    t.boolean  "grants_badge"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "processor_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.string   "state"
    t.string   "failure_reason"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "extends_slot_id"
    t.string   "title"
    t.text     "description"
    t.string   "color"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "USD", null: false
    t.boolean  "requires_character"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "swatches", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "name"
    t.string   "color"
    t.text     "notes"
    t.integer  "row_order"
    t.string   "guid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "transaction_resources", force: :cascade do |t|
    t.integer  "transaction_id"
    t.string   "processor_id"
    t.string   "type"
    t.integer  "amount_cents",             default: 0,     null: false
    t.string   "amount_currency",          default: "USD", null: false
    t.integer  "transaction_fee_cents",    default: 0,     null: false
    t.string   "transaction_fee_currency", default: "USD", null: false
    t.string   "payment_mode"
    t.string   "status"
    t.string   "reason_code"
    t.datetime "valid_until"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "payment_id"
    t.string   "processor_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.integer  "sender_user_id"
    t.integer  "destination_user_id"
    t.integer  "invitation_id"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "rejected_at"
    t.string   "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "guid"
    t.index ["guid"], name: "index_transfers_on_guid", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.text     "profile"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.json     "settings"
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

end
