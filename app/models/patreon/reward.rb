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

class Patreon::Reward < ApplicationRecord
  has_many :pledges, class_name: "Patreon::Pledge", foreign_key: :patreon_reward_id
end
