class Patreon::Reward < ApplicationRecord
  has_many :pledges, class_name: Patreon::Pledge, foreign_key: :patreon_reward_id
end
