class SearchController < ApplicationController
  def show
    @characters = Character.search_for(params[:q])
    render json: @characters, each_serializer: ImageCharacterSerializer
  end
end
