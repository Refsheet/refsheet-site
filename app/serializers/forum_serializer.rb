# == Schema Information
#
# Table name: forums
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  slug         :string
#  locked       :boolean
#  nsfw         :boolean
#  no_rp        :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  system_owned :boolean          default(FALSE)
#
# Indexes
#
#  index_forums_on_slug          (slug)
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
    object.threads.with_unread_count(scope.current_user).with_last_post_at.collect do |thread|
      Forum::ThreadsSerializer.new thread, scope: scope
    end
  end

  def path
    "/forums/#{object.slug}"
  end
end
