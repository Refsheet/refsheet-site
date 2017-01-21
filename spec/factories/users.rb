# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  username        :string
#  email           :string
#  password_digest :string
#  profile         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    profile { Faker::Lorem.paragraph }
    password 'fishsticks'
    password_confirmation 'fishsticks'

    sequence :username do |n|
      "user#{n}"
    end

    sequence :email do |n|
      "user#{n}@example.com"
    end
  end
end
