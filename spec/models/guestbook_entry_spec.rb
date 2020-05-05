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

require 'rails_helper'

describe GuestbookEntry, type: :model do
  it_is_expected_to belong_to: [
                        :author_character,
                        :author,
                        :character
                    ],
                    validate_presence_of: [
                        :message,
                        [:author, :with_message => :required],
                        [:character, :with_message => :required]
                    ],
                    not: {
                        validate_presence_of: [
                            :author_character
                        ]
                    }
end
