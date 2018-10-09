FactoryBot.define do
  factory :conversations_read_bookmark, class: 'Conversations::ReadBookmark' do
    conversation { nil }
    last_read_message { nil }
    user { nil }
  end
end
