class ShortcodesController < ApplicationController
  def show
    @character = Character.find_by(shortcode: params[:id])

    if @character
      redirect_to character_path @character.user, @character
    else
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:teapot] = 418
      Rack::Utils::HTTP_STATUS_CODES[418] = "I'm a Teapot"
      render 'application/teapot', status: :teapot
    end
  end
end
