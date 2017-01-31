# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  username        :string
#  email           :string
#  password_digest :string
#  profile         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :characters
  has_one :invitation

  validates :username, presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-z0-9][a-z0-9_]+[a-z0-9]\z/i, message: 'no special characters' },
            exclusion: { in: RouteRecognizer.instance.initial_path_segments, message: 'is reserved' },
            uniqueness: { case_sensitive: false }

  validates :email, presence: true,
            format: { with: /@/, message: 'must have @ sign' },
            uniqueness: { case_sensitive: false }

  has_secure_password

  def name
    super || username
  end

  def to_param
    username
  end

  def self.lookup(username)
    find_by('LOWER(users.username) = ?', username.downcase)
  end

  def self.lookup!(username)
    find_by!('LOWER(users.username) = ?', username.downcase)
  end
end
