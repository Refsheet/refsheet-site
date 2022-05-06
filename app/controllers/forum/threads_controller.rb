class Forum::ThreadsController < ApplicationController
  before_action :get_forum

  def index
    @threads = filter_scope @forum.threads.with_unread_count(current_user), 'updated_at'
    render json: @threads, each_serializer: Forum::ThreadsSerializer
  end

  def show
    @thread = @forum
                  .discussions
                  .includes(:user, posts: [:user, :forum, :character])
                  .with_unread_count(current_user)
                  .lookup! params[:id]

    render json: @thread, serializer: Forum::ThreadSerializer
  end

  def create
    @thread = Forum::Discussion.new thread_params

    if @thread.save
      render json: @thread, serializer: Forum::ThreadSerializer
    else
      render json: { errors: @thread.errors }, status: :bad_request
    end
  end

  private

  def get_forum
    @forum = Forum.lookup! params[:forum_id]
  end

  def thread_params
    params.require(:thread)
          .permit(
              :topic,
              :content
          )
          .merge(
              user: current_user,
              forum: @forum
          )
  end
end
