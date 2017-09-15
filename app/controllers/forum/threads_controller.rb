class Forum::ThreadsController < ApplicationController
  before_action :get_forum

  def index
    @threads = filter_scope @forum.threads, 'updated_at'
    render json: @threads, each_serializer: Forum::ThreadsSerializer
  end

  def show
    @thread = @forum.threads.lookup! params[:id]

    respond_to do |format|
      format.json do
        render json: @thread, serializer: Forum::ThreadSerializer
      end

      format.html do
        set_meta_tags(
            title: @thread.topic,
            description: @thread.content.to_text.truncate(120)
        )

        eager_load :forum, @forum, ForumSerializer
        eager_load :thread, @thread, Forum::ThreadSerializer

        render 'application/show'
      end
    end
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
