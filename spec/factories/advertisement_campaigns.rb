# == Schema Information
#
# Table name: advertisement_campaigns
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  title              :string
#  caption            :string
#  link               :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  amount_cents       :integer          default("0"), not null
#  amount_currency    :string           default("USD"), not null
#  slots_filled       :integer          default("0")
#  guid               :string
#  status             :string
#  starts_at          :datetime
#  ends_at            :datetime
#  recurring          :boolean          default("false")
#  total_impressions  :integer          default("0")
#  total_clicks       :integer          default("0")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slots_requested    :integer          default("0")
#
# Indexes
#
#  index_advertisement_campaigns_on_guid     (guid)
#  index_advertisement_campaigns_on_user_id  (user_id)
#

FactoryBot.define do
  factory :advertisement_campaign, class: 'Advertisement::Campaign' do
    title { Faker::Book.title[0,30] }
    caption { Faker::Lorem.characters(70) }
    link { Faker::Internet.url }
    image_file_name { Rails.root.join 'spec/assets/advertisement_test.png' }
    amount { 5.00 }
    slots_filled { 1 }
    recurring { false }
  end
end
