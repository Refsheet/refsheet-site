module Mutations
  class ForumPostMutations < ApplicationMutation
    before_action :get_discussion, only: [:index, :create, :send_karma]

    action :index do
      type types[Types::ForumPostType]

      argument :discussionId, !types.ID
    end

    def index
      Forum.all
    end

    action :show do
      type Types::ForumPostType

      argument :guid, !types.ID
    end

    def show
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
      @discussion.posts.create! post_params
    end

    action :update do
      type Types::ForumPostType
    end

    def update

    end


    action :send_karma do
      type Types::ForumPostType

      argument :discussionId, !types.ID
      argument :take, types.Boolean
    end

    def send_karma
      value = params[:take] ? -1 : 1
      @discussion.karmas.for_user(current_user).destroy_all
      @discussion.karmas.create(user: current_user, value: value)
      @discussion.reload
      @discussion
    end

    private

    def get_discussion
      @discussion = Forum::Discussion.find_by!(id: params[:discussionId])
    end

    def post_params
      user = context.current_user.call
      character = nil

      if params[:characterId]
        character = user.characters.find(params[:characterId])
      end

      params
          .permit(:content)
          .merge(
              user: user,
              character: character
          )
    end
  end
end