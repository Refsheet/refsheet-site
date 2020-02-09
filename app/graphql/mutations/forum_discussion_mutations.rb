module Mutations
  class ForumDiscussionMutations < ApplicationMutation
    before_action :get_forum, only: [:show, :create]

    action :show do
      type Types::ForumDiscussionType

      argument :forumId, !types.String
      argument :id, !types.String
    end

    def show
      @discussion = @forum.threads.find_by!(slug: params[:id])
      @discussion
    end

    action :create do
      type Types::ForumDiscussionType

      argument :forumId, !types.String
      argument :topic, !types.String
      argument :content, !types.String
      argument :locked, types.Boolean
    end

    def create
      @discussion = Forum::Discussion.new(discussion_props)
      authorize @discussion
      @discussion.save!
      @discussion
    end

    private

    def discussion_props
      params
          .permit(
              :topic,
              :content,
              :locked,
          )
          .merge(
              user: current_user,
              forum: @forum
          )
    end

    def get_forum
      @forum = Forum.find_by!(slug: params[:forumId])
    end
  end
end