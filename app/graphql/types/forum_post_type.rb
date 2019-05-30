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
Types::ForumPostType = GraphQL::ObjectType.define do
  name 'ForumPost'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :guid, !types.ID
  field :content, types.String
  field :content_html, types.String
  field :karma_total, types.Int

  field :user, Types::UserType
  field :character, Types::CharacterType
  field :parent_post, 'Types::ForumPostType'
  field :discussion, Types::ForumDiscussionType, property: :thread
end