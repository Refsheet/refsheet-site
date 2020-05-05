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

class GuestbookEntry < ApplicationRecord
  belongs_to :character, optional: false
  belongs_to :author, class_name: 'User', foreign_key: :author_user_id, optional: false
  belongs_to :author_character, class_name: 'Character', foreign_key: :author_character_id

  validates_presence_of :message
end
