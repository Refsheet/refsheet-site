class Mutations::MediaCommentMutations < Mutations::ApplicationMutation
  before_action :get_media

  action :index do
    type Types::MediaCommentCollectionType
    argument :mediaId, !types.ID
    argument :page, types.Int
    argument :perPage, types.Int
    argument :since, types.Int
  end

  def index
    scope = @media.comments.order(:created_at => :desc)

    unless params[:since].nil?
      since = Time.zone.at(params[:since])
      scope = scope.where('media_comments.created_at >= ?', since)
    end

    unless params[:page].nil?
      scope = scope.paginate(page: params[:page], per_page: params[:perPage])
    end

    scope
  end

  action :create do
    type Types::MediaCommentType
    argument :mediaId, !types.ID
    argument :comment, !types.String
  end

  def create
    @comment = Media::Comment.create media: @media,
                                     user: context.current_user.call,
                                     comment: params[:comment]
  end

  action :destroy do
    type Types::MediaCommentType
    argument :mediaId, !types.ID
    argument :id, !types.ID
  end

  def destroy
    @comment = @media.comments.find_by! guid: params[:id]
    authorize! @media.managed_by?(current_user) || @comment.user == current_user
    @comment.destroy
    @comment
  end

  private

  def get_media
    @media = Image.find_by! guid: params[:mediaId]
  end
end