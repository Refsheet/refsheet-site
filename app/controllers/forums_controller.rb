class ForumsController < ApplicationController
  def index
    @forums = filter_scope Forum.all, 'name'

    respond_to do |format|
      format.json do
        render json: {}
      end

      format.html do
        # Set Meta
        set_meta_tags(
            title: 'Forums'
        )

        render 'application/show'
      end
    end
  end
end
