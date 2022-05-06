# == Schema Information
#
# Table name: forums
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  slug              :string
#  locked            :boolean
#  nsfw              :boolean
#  no_rp             :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  system_owned      :boolean          default(FALSE)
#  rules             :text
#  prepost_message   :text
#  owner_id          :integer
#  fandom_id         :integer
#  open              :boolean          default(FALSE)
#  summary           :text
#  discussions_count :integer          default(0), not null
#  members_count     :integer          default(0), not null
#  posts_count       :integer          default(0), not null
#
# Indexes
#
#  index_forums_on_fandom_id     (fandom_id)
#  index_forums_on_lower_slug    (lower((slug)::text) varchar_pattern_ops)
#  index_forums_on_owner_id      (owner_id)
#  index_forums_on_system_owned  (system_owned)
#

class ForumSerializer < ActiveModel::Serializer
  attributes :name,
             :description,
             :slug,
             :locked,
             :nsfw,
             :no_rp,
             :group_name,
             :thread_count,
             :path,
             :threads

  # has_many :threads, serializer: Forum::ThreadsSerializer

  def threads
    object.discussions.with_unread_count(scope).with_last_post_at.collect do |discussion|
      Forum::ThreadsSerializer.new discussion, scope: scope
    end
  end

  def thread_count
    object.discussions_count
  end

  def path
    "/forums/#{object.slug}"
  end
end
