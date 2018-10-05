# == Schema Information
#
# Table name: invitations
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  email            :string
#  seen_at          :datetime
#  claimed_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auth_code_digest :string
#

FactoryBot.define do
  factory :invitation do
    email { Faker::Internet.email }
    skip_emails { true }

    trait :send_emails do
      skip_emails { false }
    end
  end
end
