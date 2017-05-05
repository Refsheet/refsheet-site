class Media::CommentsController < ApplicationController
  before_action :get_media
  before_action :get_comment, only: [:destroy]
  before_action :get_reply_to, only: [:create]

  respond_to :json

  def index
    @comments = @media.comments
    respond_with @comments, location: nil, serializer: Media::CommentSerializer
  end

  def create
    @comment = Media::Comment.create create_params
    respond_with @comment, location: nil, serializer: Media::CommentSerializer
  end

  def destroy
    @comment.destroy
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
