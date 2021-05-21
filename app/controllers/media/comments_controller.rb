class Media::CommentsController < ApplicationController
  before_action :get_media
  before_action :get_comment, only: [:destroy]
  before_action :get_reply_to, only: [:create]

  respond_to :json

  def index
    @comments = @media.comments.includes(:media, :reply_to, :user, :replies)
    respond_with @comments, location: nil, each_serializer: Media::CommentSerializer
  end

  def create
    @comment = Media::Comment.new create_params
    authorize @comment
    @comment.save
    respond_with @comment, location: nil, serializer: Media::CommentSerializer
  end

  def destroy
    @comment.destroy
    authorize @comment
    respond_with @comment, location: nil
  end

  private

  def get_media
    @media = Image.find_by! guid: params[:media_id]
  end

  def get_comment
    @comment = @media.comments.find_by! guid: params[:id]
  end

  def get_reply_to
    @reply_to = @media.comments.find_by guid: params[:reply_to_comment_id]
  end

  def create_params
    params.require(:comment)
        .permit(:comment)
        .merge(
            media: @media,
            user: current_user,
            reply_to: @reply_to
        )
  end
end
