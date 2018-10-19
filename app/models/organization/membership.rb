class Organization::Membership < ApplicationRecord
  belongs_to :user, inverse_of: :organization_memberships
  belongs_to :organization, inverse_of: :memberships

  validates_presence_of :user
  validates_presence_of :organization

  scope :admin, -> { where admin: true }
end
