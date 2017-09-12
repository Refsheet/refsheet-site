# == Schema Information
#
# Table name: forum_threads
#
#  id           :integer          not null, primary key
#  forum_id     :integer
#  user_id      :integer
#  character_id :integer
#  topic        :string
#  slug         :string
#  shortcode    :string
#  content      :text
#  locked       :boolean
#  karma_total  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Forum::Discussion, type: :model do
  it_is_expected_to(
      belong_to: [
          :forum,
          :user,
          :character
      ],
      have_many: [
          :posts,
          :karmas
      ],
      validate_presence_of: [
          :topic,
          :content,
          :user,
          :slug
      ]
  )
end
