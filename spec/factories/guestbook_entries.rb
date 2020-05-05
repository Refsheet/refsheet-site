# == Schema Information
#
# Table name: guestbook_entries
#
#  id                  :bigint           not null, primary key
#  character_id        :bigint
#  author_user_id      :bigint
#  author_character_id :bigint
#  message             :text
#  deleted_at          :datetime
#  guid                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_guestbook_entries_on_author_character_id  (author_character_id)
#  index_guestbook_entries_on_author_user_id       (author_user_id)
#  index_guestbook_entries_on_character_id         (character_id)
#  index_guestbook_entries_on_deleted_at           (deleted_at)
#  index_guestbook_entries_on_guid                 (guid)
#

FactoryBot.define do
  factory :guestbook_entry do
    character_id { nil }
    author_user_id { nil }
    author_character_id { nil }
    message { "MyText" }
    deleted_at { "2020-05-05 00:43:00" }
    guid { "MyString" }
  end
end
