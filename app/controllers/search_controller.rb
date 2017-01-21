class SearchController < ApplicationController
  def show
    @characters = Character.search_for(params[:q]).order(<<-SQL)
      CASE
        WHEN characters.profile_image_id IS NULL THEN '1'
        WHEN characters.profile_image_id IS NOT NULL THEN '0'
      END, lower(characters.name) ASC
    SQL

    render json: @characters, each_serializer: ImageCharacterSerializer
  end
end
