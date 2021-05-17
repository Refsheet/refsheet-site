FactoryBot.define do
  factory :media_folder, class: 'Media::Folder' do
    name { Faker::Ancient.name }
    user { build :user }
    character { build :character, user: user }
    hidden { false }
    nsfw { false }
  end
end
