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

  def self.[](tag)
    find_or_initialize_by tag: tag
  end
end
