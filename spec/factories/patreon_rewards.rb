# == Schema Information
#
# Table name: patreon_rewards
#
#  id                :integer          not null, primary key
#  patreon_id        :string
#  amount_cents      :integer
#  description       :text
#  image_url         :string
#  requires_shipping :boolean
#  title             :string
#  url               :string
#  grants_badge      :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_patreon_rewards_on_patreon_id  (patreon_id)
#

FactoryBot.define do
  factory :patreon_reward, class: 'Patreon::Reward' do
    patreon_id { "MyString" }
    amount_cents { 1 }
    description { "MyText" }
    image_url { "MyString" }
    requires_shipping { false }
    title { "MyString" }
    url { "MyString" }
    grants_badge { false }
  end
end
