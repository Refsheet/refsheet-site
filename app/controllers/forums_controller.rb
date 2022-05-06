class ForumsController < ApplicationController
  def index
    @forums = filter_scope Forum.all, 'name'

    render json: @forums, each_serializer: ForumsSerializer
  end

  def show
    @forum = Forum.lookup! params[:id]

    render json: @forum, serializer: ForumSerializer
  end
end
