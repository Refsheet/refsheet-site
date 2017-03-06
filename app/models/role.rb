class Role < ApplicationRecord
  has_many :permissions
  has_many :users, through: :permissions

  validates :name, presence: true, uniqueness: true, format: { with: /\A\w+\z/, message: 'must be sym' }
  before_validation -> { name&.downcase! }
end
