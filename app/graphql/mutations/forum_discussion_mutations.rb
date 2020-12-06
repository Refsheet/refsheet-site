module Mutations
  class ForumDiscussionMutations < ApplicationMutation
    before_action :get_forum, only: [:show, :create]
    before_action :get_discussion, only: [:update, :destroy]

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
      argument :sticky, types.Boolean
    end

    def create
      @discussion = Forum::Discussion.new(discussion_props)
      authorize @discussion
      @discussion.save!
      @discussion
    end

    action :update do
      type Types::ForumDiscussionType

      argument :id, !types.ID
      argument :topic, types.String
      argument :content, types.String
      argument :locked, types.Boolean
      argument :sticky, types.Boolean
    end

    def update
      authorize @discussion
      @discussion.update_attributes!(discussion_params)
      @discussion
    end

    action :destroy do
      type Types::ForumDiscussionType

      argument :id, !types.ID
    end

    def destroy
      authorize @discussion
      @discussion.destroy
      @discussion
    end

    private

    def discussion_props
      # TODO: This should be update params + merge
      params
          .permit(
              :topic,
              :content,
              :locked,
              :sticky
          )
          .merge(
              user: current_user,
              forum: @forum
          )
    end

    def discussion_params
      # TODO this should be create and edit params, not props
      params
          .permit(
              :topic,
              :content,
              :locked,
              :sticky
          )
    end

    def get_forum
      @forum = Forum.find_by!(slug: params[:forumId])
    end

    def get_discussion
      @discussion = Forum::Discussion.find_by!(id: params[:id])
    end
  end
end
