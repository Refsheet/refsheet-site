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
#

FactoryGirl.define do
  factory :feedback do
    user_id 1
    name "MyString"
    email "MyString"
    comment "MyText"
    trello_card_id "MyString"
    source_url "MyString"
    ahoy_visit_id 1
  end
end
