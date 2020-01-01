# == Schema Information
#
# Table name: media_hashtags
#
#  id         :integer          not null, primary key
#  tag        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Media::Hashtag < ApplicationRecord
  include NamespacedModel

  has_and_belongs_to_many :media, class_name: "Image", foreign_key: :media_hashtag_id

  def self.[](tag)
    find_or_initialize_by tag: tag
  end

  def count
    media.count
  end
end
