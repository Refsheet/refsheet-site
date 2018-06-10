# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string
#  email          :string
#  comment        :text
#  trello_card_id :string
#  source_url     :string
#  visit_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  done           :boolean
#  freshdesk_id   :string
#

FactoryGirl.define do
  factory :feedback do
    user
    comment { Faker::Lorem.paragraph }
    skip_freshdesk true

    trait :freshdesk do
      skip_freshdesk false
    end
  end
end
