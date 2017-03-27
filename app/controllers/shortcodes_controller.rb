class ShortcodesController < ApplicationController
  def show
    @character = Character.find_by(shortcode: params[:id].downcase)

    if @character
      redirect_to "https://refsheet.net/#{@character.user.username.downcase}/#{@character.slug.downcase}"
    else
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:teapot] = 418
      Rack::Utils::HTTP_STATUS_CODES[418] = "I'm a Teapot"
      render 'application/teapot', status: :teapot
    end
  end
end
