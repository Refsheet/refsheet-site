class Admin::ForumsController < AdminController
  before_action :get_forum, only: [:show, :update]

  add_breadcrumb 'Forums', :admin_forums_path

  before_action do
    @search = { path: admin_forums_path }
  end

  def index
    @forums = @scope = filter_scope Forum
    @forums = @forums.group_by { |f| f.group_name }
    @forum = Forum.new
  end

  def show
    add_breadcrumb @forum.name, admin_forum_path(@forum)
  end

  def create
    @forum = Forum.create forum_params
    respond_with :admin, @forum, action: :index
  end

  def update
    @forum.update_attributes forum_params
    respond_with :admin, @forum, action: :show
  end

  private

  def get_forum
    @forum = Forum.lookup! params[:id]
  end

  def forum_params
    params.require(:forum)
          .permit(
              :name,
              :description,
              :locked,
              :nsfw,
              :no_rp
          )
  end
end
