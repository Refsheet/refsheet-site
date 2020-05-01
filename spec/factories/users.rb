# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  username              :string
#  email                 :string
#  password_digest       :string
#  profile               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  avatar_file_name      :string
#  avatar_content_type   :string
#  avatar_file_size      :bigint
#  avatar_updated_at     :datetime
#  settings              :json
#  type                  :string
#  auth_code_digest      :string
#  parent_user_id        :integer
#  unconfirmed_email     :string
#  email_confirmed_at    :datetime
#  deleted_at            :datetime
#  avatar_processing     :boolean
#  support_pledge_amount :integer          default(0)
#  guid                  :string
#  admin                 :boolean
#  patron                :boolean
#  supporter             :boolean
#  moderator             :boolean
#
# Indexes
#
#  index_users_on_deleted_at      (deleted_at)
#  index_users_on_guid            (guid)
#  index_users_on_parent_user_id  (parent_user_id)
#  index_users_on_type            (type)
#

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    profile { Faker::Lorem.paragraph }
    password { 'fishsticks' }
    password_confirmation { password }
    skip_emails { true }

    sequence :username do |n|
      "user#{n}"
    end

    sequence :email do |n|
      "user#{n}@example.com"
    end

    trait :send_emails do
      skip_emails { false }
    end

    trait :is_seller do
      seller
    end

    trait :confirmed do
      after(:create) do |user|
        user.confirm!
      end
    end

    trait :with_characters do
      transient do
        characters_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:character, evaluator.characters_count, user: user)
      end
    end

    trait :with_character_groups do
      transient do
        character_groups_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:character_group, evaluator.character_groups_count, user: user)
        user.character_groups.each do |cg|
          cg.characters << user.characters
        end
      end
    end

    factory :admin do
      roles {[ Role.find_or_initialize_by(name: 'admin') ]}
    end

    factory :patron do
      after(:build) do |user, _evaluator|
        user.patron_patron = create(:patreon_patron)
        user.patron = true
      end
    end
  end
end
