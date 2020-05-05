class GuestbookEntry < ApplicationRecord
  belongs_to :character, optional: false
  belongs_to :author, class_name: 'User', foreign_key: :author_user_id, optional: false
  belongs_to :author_character, class_name: 'Character', foreign_key: :author_character_id

  validates_presence_of :message
end
