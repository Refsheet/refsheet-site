module Mutations
  class ForumPostMutations < ApplicationMutation
    before_action :get_discussion, only: [:create, :send_karma]
    before_action :get_post, only: [:update]

    action :index, :paginated do
      type Types::ForumPostsCollectionType

      argument :discussionId, types.ID
      argument :userId, types.ID
    end

    def index
      return []
      scope = Forum::Post.all
      authorize scope

      if params[:discussionId].present?
        scope = scope.joins(:discussion).where(forum_discussions: { guid: params[:discussionId] })
      end

      if params[:userId].present?
        scope = scope.joins(:user).where(users: { guid: params[:userId] })
      end

      scope = scope.includes(:discussion => [:forum])

      paginate(scope)
    end

    action :show do
      type Types::ForumPostType

      argument :guid, !types.ID
    end

    def show
      return nil
      Forum.find_by(slug: params[:slug])
    end

    action :create do
      type Types::ForumPostType

      argument :discussionId, !types.ID
      argument :content, !types.String
      argument :characterId, types.ID
      argument :parentPostId, types.ID
    end

    def create
      return nil
      @discussion.posts.create! post_params
    end

    action :update do
      type Types::ForumPostType

      argument :postId, !types.ID
      argument :content, !types.String
    end

    def update
      return nil
      authorize @post
      @post.update!(post_update_params)
      @post
    end


    action :send_karma do
      type Types::ForumPostType

      argument :discussionId, !types.ID
      argument :take, types.Boolean
    end

    def send_karma
      return nil
      value = params[:take] ? -1 : 1
      @discussion.karmas.for_user(current_user).destroy_all
      @discussion.karmas.create(user: current_user, value: value)
      @discussion.reload
      @discussion
    end

    private

    def get_discussion
      return nil
      @discussion = Forum::Discussion.find_by!(id: params[:discussionId])
    end

    def get_post
      return nil
      @post = Forum::Post.find_by!(guid: params[:postId])
    end

    def post_params
      user = context.current_user.call
      character = nil

      if params[:characterId]
        character = user.characters.find_by!(guid: params[:characterId])
      end

      params
          .permit(:content)
          .merge(
              user: user,
              character: character
          )
    end

    def post_update_params
      params.permit(:content)
    end
  end
end
