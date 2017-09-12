# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :integer
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe Forum::Post, type: :model do
  it_is_expected_to(
      belong_to: [
          :thread,
          :user,
          :character,
          :parent_post
      ],
      have_many: [
          :replies,
          :karmas
      ],
      have_one: [
          :forum
      ],
      validate_presence_of: [
          :thread,
          :user,
          :content
      ]
  )
end
