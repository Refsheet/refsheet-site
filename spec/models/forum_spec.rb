# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_forums_on_slug  (slug)
#

require 'rails_helper'

describe Forum, type: :model do
  it_is_expected_to(
      have_many: [
          :threads,
          :posts
      ],
      validate_presence_of: [
          :name,
          :slug
      ]
  )
end
