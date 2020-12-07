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
#  admin_post     :boolean          default(FALSE)
#  moderator_post :boolean          default(FALSE)
#  deleted_at     :datetime
#  edited         :boolean          default(FALSE)
#
# Indexes
#
#  index_forum_posts_on_character_id    (character_id)
#  index_forum_posts_on_deleted_at      (deleted_at)
#  index_forum_posts_on_guid            (guid)
#  index_forum_posts_on_parent_post_id  (parent_post_id)
#  index_forum_posts_on_thread_id       (thread_id)
#  index_forum_posts_on_user_id         (user_id)
#

require 'rails_helper'

describe Forum::Post, type: :model do
  it_is_expected_to(
      belong_to: [
          :discussion,
          :user,
          :character,
          :parent_post
      ],
      have_many: [
          :replies,
          :karmas,
          :versions
      ],
      have_one: [
          :forum
      ],
      validate_presence_of: [
          :discussion,
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
    expect(post.content_html).to eq "<h1 id=\"hello\">Hello!</h1>\n"
  end

  it 'flags content changes' do
    post = create :forum_post
    expect(post).to_not be_edited
    expect(post).to_not be_admin_post

    post.update(user: create(:admin))
    expect(post).to_not be_edited
    expect(post).to be_admin_post

    post.update(content: 'Okay I changed it.')
    expect(post).to be_edited
  end
end
