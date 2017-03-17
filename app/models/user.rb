# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  username            :string
#  email               :string
#  password_digest     :string
#  profile             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  settings            :json
#

class User < ApplicationRecord
  has_many :characters
  has_many :permissions
  has_many :roles, through: :permissions
  has_one  :patron, class_name: Patreon::Patron
  has_many :pledges, through: :patron

  validates :username, presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-z0-9][a-z0-9_]+[a-z0-9]\z/i, message: 'no special characters' },
            exclusion: { in: RouteRecognizer.instance.initial_path_segments, message: 'is reserved' },
            uniqueness: { case_sensitive: false }

  validates :email, presence: true,
            format: { with: /@/, message: 'must have @ sign' },
            uniqueness: { case_sensitive: false }

  has_secure_password

  has_attached_file :avatar,
                    styles: {
                        thumbnail: '64x64#',
                        small_square: '427x427#',
                        small: '427x>',
                        medium_square: '854x854#',
                        medium: '854x>'
                    },
                    s3_permissions: {
                        original: :private
                    }

  validates_attachment :avatar,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..25.megabytes }

  serialize :settings, JSON

  scoped_search on: [:name, :username, :email]

  def name
    super || username
  end

  def to_param
    username
  end

  def avatar_url
    self.avatar? ? self.avatar.url(:thumbnail) : GravatarImageTag.gravatar_url(self.email)
  end

  def settings
    HashWithIndifferentAccess.new(super)
  end

  def profile_image_url
    self.avatar? ? self.avatar.url(:small_square) : GravatarImageTag.gravatar_url(self.email, size: 200)
  end

  def self.lookup(username)
    find_by('LOWER(users.username) = ?', username.downcase)
  end

  def self.lookup!(username)
    find_by!('LOWER(users.username) = ?', username.downcase)
  end

  def role?(role)
    self.roles.exists?(name: role.to_s)
  end
end
