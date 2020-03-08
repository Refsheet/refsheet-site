# == Schema Information
#
# Table name: api_keys
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  guid          :string
#  secret_digest :string
#  read_only     :boolean          default(FALSE)
#  name          :string
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_api_keys_on_guid     (guid)
#  index_api_keys_on_user_id  (user_id)
#

class ApiKey < ApplicationRecord
  include HasGuid

  belongs_to :user

  acts_as_paranoid
  has_guid

  validates_presence_of :secret_digest

  before_validation :generate_secret

  # TODO: Uncomment after Rails 6
  #has_secure_password :secret

  # TODO: Remove after Rails 6
  attr_reader :secret
  def authenticate_secret(cleartext)
    BCrypt::Password.new(secret_digest) == cleartext
  end

  private

  # TODO: Refactor after Rails 6 to assign self.secret=
  def generate_secret
    return if secret_digest.present?
    @secret = SecureRandom.hex(32)
    self.secret_digest = BCrypt::Password.create(@secret)
  end
end
