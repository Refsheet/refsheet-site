class ShortcodesController < ApplicationController
  def show
    @character = Character.find_by!(shortcode: params[:id])
    redirect_to @character
  end
end
