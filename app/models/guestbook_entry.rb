class GuestbookEntry < ApplicationRecord
  belongs_to :character
  belongs_to :author, class_name: 'User', foreign_key: :author_user_id
  belongs_to :author_character, class_name: 'Character', foreign_key: :author_character_id
end
