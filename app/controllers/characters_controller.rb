class CharactersController < ApplicationController
  before_action :get_user
  before_action :get_character, except: [:create]

  def show
    respond_to do |format|
      format.json { render json: @character, serializer: CharacterSerializer }
      format.html { render 'application/show' }
    end
  end

  def create
    @character = Character.new character_params.merge(user: current_user)
    if @character.save
      render json: @character
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  def update
    if @character.update_attributes character_params
      render json: @character, serializer: CharacterSerializer
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  private

  def get_user
    @user = User.find_by!('LOWER(users.username) = ?', params[:user_id].downcase)
  end

  def get_character
    @character = @user.characters.find_by!('LOWER(characters.slug) = ?', params[:id].downcase)
  end

  def character_params
    p = params.require(:character).permit(:name, :nickname, :gender, :species, :height, :weight,
                                          :body_type, :personality, :special_notes, :profile, :likes, :dislikes)

    if params[:character].include? :profile_image_guid
      p[:profile_image] = @character.images.find_by!(guid: params[:character][:profile_image_guid])
    end

    if params[:character].include? :featured_image_guid
      p[:featured_image] = @character.images.find_by!(guid: params[:character][:featured_image_guid])
    end

    p
  end
end
