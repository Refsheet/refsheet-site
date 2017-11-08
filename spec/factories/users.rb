# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  username            :string
#  email               :string
#  password_digest     :string
#  profile             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  settings            :json
#  type                :string
#  auth_code_digest    :string
#  parent_user_id      :integer
#  unconfirmed_email   :string
#  email_confirmed_at  :datetime
#
# Indexes
#
#  index_users_on_parent_user_id  (parent_user_id)
#  index_users_on_type            (type)
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    profile { Faker::Lorem.paragraph }
    password 'fishsticks'
    password_confirmation 'fishsticks'
    skip_emails true

    sequence :username do |n|
      "user#{n}"
    end

    sequence :email do |n|
      "user#{n}@example.com"
    end

    trait :send_emails do
      skip_emails false
    end

    trait :is_seller do
      seller
    end

    trait :confirmed do
      after(:create) do |user|
        user.confirm!
      end
    end

    factory :admin do
      roles {[ Role.find_or_initialize_by(name: 'admin') ]}
    end
  end
end
