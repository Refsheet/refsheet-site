# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :string
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  content_html   :string
#
# Indexes
#
#  index_forum_posts_on_character_id    (character_id)
#  index_forum_posts_on_guid            (guid)
#  index_forum_posts_on_parent_post_id  (parent_post_id)
#  index_forum_posts_on_thread_id       (thread_id)
#  index_forum_posts_on_user_id         (user_id)
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

  it 'notifies without kaboom' do
    expect_any_instance_of(User).to receive(:notify!).and_return(true)
    expect(create :forum_post).to be_valid
  end

  it 'markdown strings' do
    post = create :forum_post
    expect(post.content).to be_a MarkdownString
  end

  it 'markdown cache' do
    post = create :forum_post, content: '# Hello!'
    expect(post.content_html).to eq '<h1>Hello!</h1>'
  end
end
