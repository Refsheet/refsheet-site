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
