class Patreon::Patron < ApplicationRecord
  has_many :pledges, class_name: Patreon::Pledge, foreign_key: :patreon_patron_id
  has_many :rewards, through: :pledges
  belongs_to :user
end
