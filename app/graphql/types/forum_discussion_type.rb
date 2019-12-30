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
#  content_html :string
#
# Indexes
#
#  index_forum_threads_on_character_id  (character_id)
#  index_forum_threads_on_forum_id      (forum_id)
#  index_forum_threads_on_karma_total   (karma_total)
#  index_forum_threads_on_shortcode     (shortcode)
#  index_forum_threads_on_slug          (slug)
#  index_forum_threads_on_user_id       (user_id)
#
Types::ForumDiscussionType = GraphQL::ObjectType.define do
  name 'ForumDiscussion'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :topic, types.String
  field :slug, types.String
  field :shortcode, types.String
  field :content, types.String
  field :content_html, types.String
  field :preview, types.String
  field :locked, types.Boolean
  field :karma_total, types.Int
  field :reply_count, types.Int

  field :forum, Types::ForumType
  field :user, Types::UserType
  field :character, Types::CharacterType

  field :posts, types[Types::ForumPostType] do
    resolve -> (obj, args, _ctx) {
      scope = obj.posts

      if args[:page]
        scope = scope.page(args[:scope])
      end

      scope
    }
  end

  field :last_read_at, types.Int do
    resolve -> (obj, _args, ctx) {
      obj.last_read_at(ctx[:current_user].call)
    }
  end

  field :last_post_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.last_post_at
    }
  end

  field :unread_posts_count, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.unread_posts_count
    }
  end
end