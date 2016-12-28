# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  url        :string
#  shortcode  :string
#  profile    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Character < ApplicationRecord
  include HasGuid

  belongs_to :user
  has_many :swatches

  has_guid :shortcode, type: :token

  validates_presence_of :user
  validates_presence_of :name
  validates_presence_of :url

  validates_uniqueness_of :url, scope: :user
  validates_uniqueness_of :shortcode

  def to_param
    url
  end
end
