# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#  nsfw              :boolean
#  hidden            :boolean          default(FALSE)
#  secret            :boolean
#  row_order         :integer
#  deleted_at        :datetime
#  custom_attributes :text
#  version           :integer          default(1)
#

FactoryBot.define do
  factory :character do
    user
    name { Faker::Name.name }
    profile { Faker::Lorem.paragraph }

    trait :hidden do
      hidden { true }
    end

    trait :with_swatches do
      after(:build) do |character, _evaluator|
        character.swatches << build_list(:swatch, 5, character: character)
      end
    end

    trait :with_images do
      after(:build) do |character, _evaluator|
        character.images << build_list(:image, 3, character: character)
        character.images << build_list(:image, 2, character: character, nsfw: true)
        character.images << build_list(:image, 1, character: character, hidden: true)
      end
    end
  end
end
