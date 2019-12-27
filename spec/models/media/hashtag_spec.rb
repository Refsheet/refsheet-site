# == Schema Information
#
# Table name: media_hashtags
#
#  id         :integer          not null, primary key
#  tag        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Media::Hashtag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
