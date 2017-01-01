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

  validates_presence_of :username
  validates_presence_of :email

  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_format_of :email, with: /@/, message: 'must have @ sign'

  has_secure_password

  def name
    super || username
  end

  def to_param
    username
  end
end
