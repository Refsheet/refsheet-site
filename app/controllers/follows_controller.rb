class FollowsController < ApplicationController
  before_action :get_user, except: [:suggested]

  def show
    render json: {
        name: @user.name,
        username: @user.username,
        followed: @user.followed_by?(current_user),
        follower: @user.following?(current_user),
        followers: @user.followers.count,
        following: @user.following.count
    }
  end

  def suggested
    head :unauthorized unless signed_in?

    scope = current_user.followers.suggested
    scope = User.patrons if scope.none?

    render json: filter_scope(scope), each_serializer: UserIndexSerializer
  end

  def create
    head :unauthorized unless signed_in?

    if current_user.follow! @user
      @user.reload
      show
    else
      render json: { error: 'You can\'t follow that account.' }, status: :bad_request
    end
  end

  def destroy
    head :unauthorized unless signed_in?

    if current_user.unfollow! @user
      @user.reload
      show
    else
      render json: { error: 'Something bad did happen, I say.' }, status: :bad_request
    end
  end

  private

  def get_user
    @user = User.lookup! params[:user_id]
  end
end
