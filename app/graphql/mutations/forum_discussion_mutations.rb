module Mutations
  class ForumDiscussionMutations < ApplicationMutation
    before_action :get_forum, only: [:show]

    action :show do
      type Types::ForumDiscussionType

      argument :forumId, !types.String
      argument :id, !types.String
    end

    def show
      @discussion = @forum.threads.find_by!(slug: params[:id])
      @discussion
    end

    private

    def get_forum
      @forum = Forum.find_by!(slug: params[:forumId])
    end
  end
end