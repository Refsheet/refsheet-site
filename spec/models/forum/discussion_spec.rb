# == Schema Information
#
# Table name: forum_threads
#
#  id             :integer          not null, primary key
#  forum_id       :integer
#  user_id        :integer
#  character_id   :integer
#  topic          :string
#  slug           :string
#  shortcode      :string
#  content        :text
#  locked         :boolean
#  karma_total    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  content_html   :string
#  sticky         :boolean
#  admin_post     :boolean
#  moderator_post :boolean
#  posts_count    :integer          default(0), not null
#
# Indexes
#
#  index_forum_threads_on_character_id     (character_id)
#  index_forum_threads_on_forum_id         (forum_id)
#  index_forum_threads_on_karma_total      (karma_total)
#  index_forum_threads_on_lower_shortcode  (lower((shortcode)::text))
#  index_forum_threads_on_lower_slug       (lower((slug)::text) varchar_pattern_ops)
#  index_forum_threads_on_sticky           (sticky)
#  index_forum_threads_on_user_id          (user_id)
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

  it '::with_unread_count' do
    d = create :forum_discussion, topic: 'Subscribed'
    d2 = create :forum_discussion, topic: 'NOT subscribed', forum: d.forum
    p1 = create :forum_post, discussion: d, created_at: 2.hours.ago
    p2 = create :forum_post, discussion: d, created_at: 1.minute.ago
    s = create :forum_subscription, discussion: d, last_read_at: 1.hour.ago

    da = Forum::Discussion.with_unread_count(s.user)
    dq = Forum::Discussion.with_unread_count(s.user).find(d.id)
    ds = da.first

    expect(da.count(:all)).to eq 2
    expect(da.last.topic).to eq d2.topic

    expect(ds.posts.count).to eq 2
    expect(ds.unread_posts_count).to eq 1
    expect(ds.topic).to eq d.topic

    # Last Read Cache
    expect(ds.last_read_cache).to be_truthy
    expect(dq.posts.first.thread.last_read_cache).to be_truthy

    # Skip Cache
    expect(p1).to be_read_by(s.user)
    expect(p2).to_not be_read_by(s.user)

    # Implied Cache
    expect(ds.posts.first).to be_read_by
    expect(ds.posts.last).to_not be_read_by

    # Serializer Madness
    ds.posts.collect do |post|
      expect(post.thread.attributes).to include 'last_read_cache'
    end
  end

  it 'assigns admin level' do
    u = create :admin
    d = create :forum_discussion, user: u
    expect(d.admin_post).to eq true
  end
end
