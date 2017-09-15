class Forum::PostsController < ApplicationController
  in_beta!

  before_action :get_forum
  before_action :get_thread

  def create
    @post = Forum::Post.new post_params

    if @post.save
      render json: @post, serializer: Forum::PostSerializer
    else
      render json: { errors: @post.errors }, status: :bad_request
    end
  end

  private

  def get_forum
    @forum = Forum.lookup! params[:forum_id]
  end

  def get_thread
    @thread = @forum.threads.lookup! params[:thread_id]
  end

  def post_params
    params.require(:post)
        .permit(
            :content
        )
        .merge(
            user: current_user,
            thread: @thread
        )
  end
end
