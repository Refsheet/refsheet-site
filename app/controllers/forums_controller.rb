class ForumsController < ApplicationController
  def index
    @forums = filter_scope Forum.all, 'name'

    respond_to do |format|
      format.json do
        render json: @forums, each_serializer: ForumsSerializer
      end

      format.html do
        set_meta_tags(
            title: 'Forums'
        )

        eager_load :forums, @forums, ForumsSerializer

        render 'application/show'
      end
    end
  end
end
