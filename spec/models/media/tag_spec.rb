# == Schema Information
#
# Table name: media_tags
#
#  id           :integer          not null, primary key
#  media_id     :integer
#  character_id :integer
#  position_x   :integer
#  position_y   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_media_tags_on_character_id  (character_id)
#  index_media_tags_on_media_id      (media_id)
#

require 'rails_helper'

RSpec.describe Media::Tag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
