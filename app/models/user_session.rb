# == Schema Information
#
# Table name: user_sessions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  ahoy_visit_id        :integer
#  session_guid         :string
#  session_token_digest :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_ahoy_visit_id  (ahoy_visit_id)
#  index_user_sessions_on_session_guid   (session_guid)
#  index_user_sessions_on_user_id        (user_id)
#

class UserSession < ApplicationRecord
  COOKIE_SUFFIX = Rails.env.production? ? '' : '-' + Rails.env

  COOKIE_SESSION_TOKEN_NAME = "_rst_st" + COOKIE_SUFFIX
  COOKIE_SESSION_ID_NAME = "_rst_sid" + COOKIE_SUFFIX
  COOKIE_USER_ID_NAME = "user_id" + COOKIE_SUFFIX

  include HasGuid

  attr_reader :session_token

  belongs_to :user, required: true
  belongs_to :ahoy_visit, class_name: 'Ahoy::Visit'

  has_guid :session_guid

  before_create do
    @session_token = SecureRandom.hex
    self.session_token_digest = BCrypt::Password.create(@session_token)
  end

  def authenticate(cleartext)
    return false unless session_token_digest.present?
    BCrypt::Password.new(session_token_digest) == cleartext
  end
end
