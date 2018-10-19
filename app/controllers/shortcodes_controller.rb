class ShortcodesController < ApplicationController
  def show
    if params[:id] =~ /\A~/
      show_user params[:id].gsub /\A~/, ''
    else
      show_character params[:id]
    end
  end

  def show_user(id)
    @user = User.lookup(id.downcase)

    if @user
      redirect_to "https://refsheet.net/#{@user.username}"
    else
      failure
    end
  end

  def show_character(id)
    @character = Character.find_by(shortcode: id.downcase)

    if @character
      redirect_to "https://refsheet.net/#{@character.user.username}/#{@character.slug}"
    else
      failure
    end
  end

  def failure
    if request.domain == 'ref.st'
      redirect_to "https://refsheet.net/c/#{params[:id]}"
    else
      render 'application/teapot', status: :teapot
    end
  end
end
