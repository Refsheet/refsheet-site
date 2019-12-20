FactoryBot.define do
  factory :media_hashtag, class: 'Media::Hashtag' do
    tag { "MyString" }
  end
end
