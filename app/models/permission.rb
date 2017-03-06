class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates_presence_of :user
  validates_presence_of :role
end
