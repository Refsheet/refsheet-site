class Patreon::Pledge < ApplicationRecord
  belongs_to :patron, class_name: Patreon::Patron, autosave: true, foreign_key: :patreon_patron_id
  belongs_to :reward, class_name: Patreon::Reward, autosave: true, foreign_key: :patreon_reward_id
end
