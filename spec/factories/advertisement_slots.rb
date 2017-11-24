# == Schema Information
#
# Table name: advertisement_slots
#
#  id                   :integer          not null, primary key
#  active_campaign_id   :integer
#  reserved_campaign_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  last_impression_at   :datetime
#
# Indexes
#
#  index_advertisement_slots_on_active_campaign_id    (active_campaign_id)
#  index_advertisement_slots_on_reserved_campaign_id  (reserved_campaign_id)
#

FactoryGirl.define do
  factory :advertisement_slot, class: 'Advertisement::Slot' do
    trait :active do
      association :active_campaign, factory: :advertisement_campaign
    end

    trait :reserved do
      association :reserved_campaign, factory: :advertisement_campaign
    end
  end
end
