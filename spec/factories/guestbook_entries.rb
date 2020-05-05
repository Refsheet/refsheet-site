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
